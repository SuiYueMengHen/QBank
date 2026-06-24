"""
题库题目文件生成器
用法：python create_questions.py
根据已有的题目数量，自动继续向下编号并创建对应文件夹和 .tex 文件。
"""

import os
import sys


def get_global_max_number(base_path):
    """扫描所有文件夹，获取当前所有题目中最大的编号"""
    max_num = 0
    if not os.path.isdir(base_path):
        return max_num
    for folder in os.listdir(base_path):
        folder_path = os.path.join(base_path, folder)
        if os.path.isdir(folder_path):
            for name in os.listdir(folder_path):
                sub_path = os.path.join(folder_path, name)
                if os.path.isdir(sub_path) and name.isdigit():
                    max_num = max(max_num, int(name))
    return max_num


def create_question_structure(base_path, title, count, start_img=True):
    """
    base_path: 题库根目录
    title: 文件夹名称（如 "31届复赛"）
    count: 要创建的题目数量
    start_img: 是否默认创建空的 image 文件夹
    """
    target_dir = os.path.join(base_path, title)
    os.makedirs(target_dir, exist_ok=True)

    global_max = get_global_max_number(base_path)
    print(f"当前题库中最大题目编号为 {global_max}，将从 {global_max + 1} 开始创建。")

    for i in range(1, count + 1):
        num = global_max + i
        q_dir = os.path.join(target_dir, str(num))
        os.makedirs(q_dir, exist_ok=True)

        # image 文件夹
        if start_img:
            img_dir = os.path.join(q_dir, "image")
            os.makedirs(img_dir, exist_ok=True)

        # 创建空的 .tex 文件
        problem_file = os.path.join(q_dir, f"{num}.tex")
        open(problem_file, "w", encoding="utf-8").close()

        solution_file = os.path.join(q_dir, f"{num}s.tex")
        open(solution_file, "w", encoding="utf-8").close()

        print(f"  [{num}] 已创建: {q_dir}")


def main():
    print("=" * 50)
    print("  题库题目生成器")
    print("=" * 50)

    # 输入文件夹名（标题）
    title = input("\n请输入文件夹名称（如：30届复赛）: ").strip()
    if not title:
        print("错误：文件夹名称不能为空！")
        sys.exit(1)

    # 输入题目数量
    try:
        count_str = input("请输入要创建的题目数量: ").strip()
        count = int(count_str)
        if count <= 0:
            print("错误：题目数量必须大于 0！")
            sys.exit(1)
    except ValueError:
        print("错误：请输入有效的数字！")
        sys.exit(1)

    # 当前脚本所在目录即为题库根目录
    base_path = os.path.dirname(os.path.abspath(__file__))

    print()
    create_question_structure(base_path, title, count)

    print(f"\n完成！已在 \"{title}\" 下创建了 {count} 道题目的结构。")


if __name__ == "__main__":
    main()
