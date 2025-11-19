## RmPIFProps Single-use | 移除PIF相关属性值 - 一次性模块
   
A single-use Magisk module to remove PiHooks/PixelProps/PlayIntegrityFix related properties in some insane(non-standard development) custom AOSP based ROMs.   
为部分有病(开发不规范)的基于AOSP的自定义ROM移除PiHooks/PixelProps/PlayIntegrityFix相关的属性值的一次性Magisk模块。
   
## Why this module exists? | 为什么存在这个模块?
   
Its existence is tied to a common story in the custom ROM scene: a well-intentioned effort that often backfires. Some custom ROMs, aiming to help users pass Play Integrity checks (e.g. for using banking apps), began directly integrating spoofing components like PlayIntegrityFix, PixelProps, or modified versions of TrickyStore into the system itself. While the goal was user convenience, the execution was flawed:
- Enabled by default, cannot be disabled: Users were given no choice.
- Cannot be uninstalled, leaves traces: These components modify system properties, leaving behind fingerprints that are never present on stock ROMs.
- Messy implementation exposes the device: These very fingerprints have now become a key indicator for apps to detect "unofficial ROMs".
---
它之所以存在，背后其实是一段自定义ROM生态中“好心办坏事”的故事。有些自定义ROM为了帮用户通过Play完整性验证 (比如为了正常使用银行类App) ，会在系统中直接内置一些“作弊”组件，例如 PlayIntegrityFix、PixelProps 或魔改的 TrickyStore。初衷或许是好的，但问题出在实现方式上：   
- 默认开启，无法关闭：用户没有选择权
- 无法卸载，痕迹残留：这些组件会修改系统属性，留下本不属于原厂系统的特征
- 实现不干净，反而暴露自己：这些特征如今反而成了某些 App 检测“非官方系统”的依据之一
   
## What does this module do? | 这个模块是干什么的？
   
In short, it's a cleanup tool.   
It's specifically designed to remove those invalid property values (PiHooks/PixelProps/PlayIntegrityFix related) that were forcibly written by the ROM and cannot be cleared otherwise. Especially after Play Integrity rule/API updates, the original integrated components often become obsolete, but their "footprints" remain. This module helps erase those footprints.   
---
简单来说，这个模块是一个 “清理工具”。   
它专门用于处理那些被 ROM 强行写入、又无法自行清除的 PiHooks/PixelProps/PlayIntegrityFix 相关的无效属性值。尤其是在 Play Integrity API更新并生效后，原先的组件可能已经失效，但它们留下的“脚印”却还在——这个模块就是来帮你擦掉这些脚印的。   
   
## A Call for Better Practices | 我想呼吁什么？

我理解 ROM 开发者想为用户提供便利的心情，但实现方式真的非常重要。

像 Magisk 模块这样用户可控制、可卸载、可更新的方案，显然是更友好、更可持续的道路。

而将功能强行固化进系统，不仅剥夺了用户的选择权，还可能因为实现不干净，导致整个 ROM 及其用户被各类应用“重点关照”，恶化大家的日用环境。

因此，这个模块是一个应对当前困境的临时方案。从长远来看，我更希望开发者们能选择更透明、更尊重用户控制权的实现方式，这才是对自定义ROM生态真正的负责与贡献。
