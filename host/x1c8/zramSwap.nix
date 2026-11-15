# 覆盖 base/zramSwap.nix 的默认值。
{ ... }:

{
  # 逻辑容量等于内存。优先级高于磁盘交换，网页先留在压缩内存里。
  zramSwap.memoryPercent = 100;
}
