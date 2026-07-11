---
title: 一个批量压缩jpg图片的脚本
date: 2026-07-10
tags:
 - python
categorys: 脚本
---

为了给博客网站的文章找些封面

图片这里找的：https://www.baozangtuku.com/dongman/index_11.html

搞了个python脚本

---


```python
import os
from PIL import Image

# ==================== 请修改这里 ====================
input_folder = r"C:\Users\Admin\Desktop\background-img"   # 原始 JPG 所在文件夹
output_folder = r"C:\Users\Admin\Desktop\background-img-output"   # 输出文件夹
target_size = (800, 450)  # (宽度, 高度)
# ===================================================

# 确保输出文件夹存在（不存在则自动创建）
os.makedirs(output_folder, exist_ok=True)

def resize_image_cover(img, target_size):
    """
    将图片等比例缩放，使其完全覆盖目标尺寸（无留白），
    然后从正中间裁剪出目标尺寸（可能裁剪掉边缘部分）。
    """
    target_w, target_h = target_size
    target_ratio = target_w / target_h

    # 获取原始宽高
    w, h = img.size
    img_ratio = w / h

    # 判断按宽度缩放还是按高度缩放
    if img_ratio > target_ratio:
        # 原图更宽 → 按高度缩放到 target_h，宽度会超出
        new_h = target_h
        new_w = int(new_h * img_ratio)
    else:
        # 原图更高或等比例 → 按宽度缩放到 target_w，高度会超出
        new_w = target_w
        new_h = int(new_w / img_ratio)

    # 等比例缩放（使用 LANCZOS 高质量算法）
    img_resized = img.resize((new_w, new_h), Image.Resampling.LANCZOS)

    # 计算居中裁剪的坐标（从正中间切出 target_w x target_h）
    left = (new_w - target_w) // 2
    top = (new_h - target_h) // 2
    right = left + target_w
    bottom = top + target_h

    # 执行裁剪
    img_cropped = img_resized.crop((left, top, right, bottom))
    return img_cropped

count = 1

# 遍历输入文件夹中的所有文件
for filename in os.listdir(input_folder):
    # 只处理 .jpg 或 .jpeg 文件（不区分大小写）
    if filename.lower().endswith(('.jpg', '.jpeg')):
        img_path = os.path.join(input_folder, filename)

        try:
            # 打开图片
            img = Image.open(img_path)

            # ---- 重要：JPG 不支持透明通道，转为 RGB 避免保存报错 ----
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')

            # 执行 等比例缩放 + 居中裁剪
            img_result = resize_image_cover(img, target_size)

            new_filename = f"background{count}.jpg"
            output_path = os.path.join(output_folder, new_filename)

            # 保存为 JPG，画质设为 90（可调，范围 1~100）
            img_result.save(output_path, 'JPEG', quality=90)
            print(f"✅ 已处理: {filename}")

            count += 1

        except Exception as e:
            print(f"❌ 处理 {filename} 时出错: {e}")

print("🎉 全部处理完成！")
```

