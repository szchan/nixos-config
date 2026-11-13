#!/usr/bin/python3
"""Run the ThinkPad-specific thermald policy with fan watchdog and recovery."""
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time
import xml.etree.ElementTree as ET

RUNTIME = Path('/run/thermald-thinkpad')
PSTATE = Path('/sys/devices/system/cpu/intel_pstate/max_perf_pct')
POWER = Path('/sys/class/powercap/intel-rapl:0/constraint_0_power_limit_uw')
WINDOW = Path('/sys/class/powercap/intel-rapl:0/constraint_0_time_window_us')
FAN_PROC = Path('/proc/acpi/ibm/fan')


def log(message):
    print(f'thermald-thinkpad: {message}', flush=True)


def chip(name):
    for p in Path('/sys/class/hwmon').glob('hwmon*'):
        try:
            if (p / 'name').read_text().strip() == name:
                return p.resolve()
        except OSError:
            continue
    raise RuntimeError(f'Missing hwmon sensor: {name}')


def temperatures(cpu, fan):
    values = [int((cpu / 'temp1_input').read_text()),
              int((fan / 'temp1_input').read_text())]
    if any(t < 1000 or t > 115000 for t in values):
        raise RuntimeError(f'Invalid temperature readings: {values}')
    return values


def element(parent, tag, text=None):
    node = ET.SubElement(parent, tag)
    if text is not None:
        node.text = str(text)
    return node


def make_policy(cpu, fan, baseline, power_baseline):
    root = ET.Element('ThermalConfiguration')
    platform = element(root, 'Platform')
    element(platform, 'Name', 'X1 Carbon Gen 8 fan-first thermal policy')
    element(platform, 'ProductName', '20U90038CD')
    element(platform, 'Preference', 'QUIET')
    sensors = element(platform, 'ThermalSensors')
    for name, path in [('maint_cpu', cpu / 'temp1_input'),
                       ('maint_ec', fan / 'temp1_input')]:
        sensor = element(sensors, 'ThermalSensor')
        element(sensor, 'Type', name)
        element(sensor, 'Path', path)
        element(sensor, 'AsyncCapable', 0)
    zones = element(platform, 'ThermalZones')
    for name in ['maint_cpu', 'maint_ec']:
        zone = element(zones, 'ThermalZone')
        element(zone, 'Type', name + '_zone')
        trips = element(zone, 'TripPoints')
        settings = [(55000, 'maint_fan', 145), (65000, 'maint_fan', 182),
                    (70000, 'maint_fan', 218), (75000, 'maint_fan', 255),
                    (88000, 'maint_cpu_ceiling', min(baseline, 80)),
                    (90000, 'maint_cpu_ceiling', min(baseline, 65)),
                    (92000, 'maint_cpu_ceiling', min(baseline, 50)),
                    (95000, 'maint_cpu_ceiling', min(baseline, 35))]
        settings += [(temp, 'maint_package_power', min(power_baseline, power))
                     for temp, power in [(85000, 25000000), (88000, 20000000),
                                         (90000, 15000000), (92000, 10000000),
                                         (95000, 7500000)]]
        for temp, device, target in settings:
            trip = element(trips, 'TripPoint')
            element(trip, 'SensorType', name)
            element(trip, 'Temperature', temp)
            element(trip, 'Hyst', 5000)
            element(trip, 'Type', 'passive')
            cooling = element(trip, 'CoolingDevice')
            element(cooling, 'Type', device)
            element(cooling, 'TargetState', target)
            element(cooling, 'SamplingPeriod', 1)
    devices = element(platform, 'CoolingDevices')
    for name, path, low, high, readback, step in [
        ('maint_fan', fan / 'pwm1', 109, 255, 0, 36),
        ('maint_cpu_ceiling', PSTATE, baseline, min(baseline, 35), 1, -5),
        ('maint_package_power', POWER.resolve(), power_baseline,
         min(power_baseline, 7500000), 1, -1000000),
    ]:
        device = element(devices, 'CoolingDevice')
        for tag, value in [('Type', name), ('Path', path), ('MinState', low),
                           ('MaxState', high), ('ReadBack', readback),
                           ('IncDecStep', step), ('DebouncePeriod', 0)]:
            element(device, tag, value)
    ET.indent(root)
    return ET.tostring(root, encoding='unicode') + '\n'


def restore():
    errors = []
    try:
        fan = chip('thinkpad')
        if (fan / 'pwm1_enable').read_text().strip() != '2':
            (fan / 'pwm1_enable').write_text('2\n')
        if Path('/sys/module/thinkpad_acpi/parameters/fan_control').read_text().strip() == 'Y':
            FAN_PROC.write_text('watchdog 0\n')
    except (OSError, RuntimeError) as e:
        errors.append(f'fan restoration: {e}')
    try:
        saved = json.loads((RUNTIME / 'original.json').read_text())
        PSTATE.write_text(str(saved['max_perf_pct']) + '\n')
        if 'power_uw' in saved:
            POWER.write_text(str(saved['power_uw']) + '\n')
            WINDOW.write_text(str(saved['window_us']) + '\n')
    except FileNotFoundError:
        pass
    except (OSError, ValueError, KeyError) as e:
        errors.append(f'CPU ceiling restoration: {e}')
    log('restored firmware auto mode and original CPU ceiling' if not errors else '; '.join(errors))
    return not errors


def run():
    if Path('/sys/class/dmi/id/product_name').read_text().strip() != '20U90038CD':
        raise RuntimeError('This policy is scoped to ThinkPad 20U90038CD')
    if Path('/sys/module/thinkpad_acpi/parameters/fan_control').read_text().strip() != 'Y':
        raise RuntimeError('fan_control=1 is not active; firmware auto mode retained')
    cpu, fan = chip('coretemp'), chip('thinkpad')
    temperatures(cpu, fan)
    baseline = int(PSTATE.read_text())
    if not 35 <= baseline <= 100:
        raise RuntimeError(f'Unexpected original max_perf_pct: {baseline}')
    RUNTIME.mkdir(mode=0o700, exist_ok=True)
    power_baseline = int(POWER.read_text())
    if power_baseline < 7500000:
        raise RuntimeError(f'Original package limit is already low: {power_baseline}')
    (RUNTIME / 'original.json').write_text(json.dumps({
        'max_perf_pct': baseline, 'power_uw': power_baseline,
        'window_us': int(WINDOW.read_text()),
    }))
    policy = RUNTIME / 'thermal-conf.xml'
    policy.write_text(make_policy(cpu, fan, baseline, power_baseline))
    FAN_PROC.write_text('watchdog 30\n')
    FAN_PROC.write_text('level 7\n')
    child = None
    stopping = False

    def stop(*_):
        nonlocal stopping
        stopping = True

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    try:
        child = subprocess.Popen([
            '/usr/bin/thermald', '--no-daemon', '--dbus-enable',
            '--ignore-cpuid-check', '--ignore-default-control',
            '--disable-active-power', '--poll-interval=1',
            '--config-file=' + str(policy), '--loglevel=info',
        ])
        log(f'started thermald pid={child.pid}; CPU={cpu}; fan={fan}')
        ticks = 0
        while not stopping:
            if child.poll() is not None:
                raise RuntimeError(f'thermald exited with status {child.returncode}')
            cpu_temp, ec_temp = temperatures(cpu, fan)
            # Native discovery/firmware can restore the original ~128s averaging
            # window. A short window makes temperature-driven PL1 changes timely.
            if int(WINDOW.read_text()) > 3000000:
                WINDOW.write_text('2000000\n')
                log('set package averaging window to approximately two seconds')
            if (fan / 'pwm1_enable').read_text().strip() != '1':
                raise RuntimeError('Firmware changed fan mode; restart and rediscover interfaces')
            # Independent high-temperature guard also covers an unresponsive thermald.
            if max(cpu_temp, ec_temp) >= 80000 and int((fan / 'pwm1').read_text()) < 255:
                (fan / 'pwm1').write_text('255\n')
                log('high-temperature guard requested normal maximum fan')
            if max(cpu_temp, ec_temp) >= 98000 and int(PSTATE.read_text()) > 35:
                PSTATE.write_text('35\n')
                log('high-temperature guard limited CPU ceiling to 35%')
            if max(cpu_temp, ec_temp) >= 98000 and int(POWER.read_text()) > 7500000:
                POWER.write_text('7500000\n')
                log('high-temperature guard limited package to 7.5W')
            if ticks % 5 == 0:
                FAN_PROC.write_text('watchdog 30\n')
            if ticks % 30 == 0:
                log(f'temperatures={cpu_temp}/{ec_temp}mC rpm={(fan / "fan1_input").read_text().strip()} max_perf_pct={PSTATE.read_text().strip()} package_limit_uw={POWER.read_text().strip()}')
            ticks += 1
            time.sleep(1)
    finally:
        if child is not None and child.poll() is None:
            child.terminate()
            try:
                child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                child.kill()
                child.wait(timeout=5)
        restore()


if __name__ == '__main__':
    if os.geteuid() != 0:
        raise SystemExit('Root required')
    if sys.argv[1:] == ['--restore']:
        raise SystemExit(0 if restore() else 1)
    try:
        run()
    except Exception as error:
        log(str(error))
        restore()
        raise SystemExit(1)
