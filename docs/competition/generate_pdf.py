"""Generate MoonPathfinding proposal PDF — one-page compact style."""
from fpdf import FPDF
import os

chinese_font = None
for fp in [
    "C:/Windows/Fonts/msyh.ttc",
    "C:/Windows/Fonts/msyhbd.ttc",
    "C:/Windows/Fonts/simsun.ttc",
    "C:/Windows/Fonts/simhei.ttf",
]:
    if os.path.exists(fp):
        chinese_font = fp
        break
if not chinese_font:
    print("ERROR: No Chinese font found!")
    exit(1)

class PDF(FPDF):
    def __init__(self):
        super().__init__()
        self.add_font("F", "", chinese_font)
        self.add_font("F", "B", chinese_font)

    def header(self):
        pass

    def footer(self):
        pass

    def title_line(self):
        self.set_fill_color(50, 50, 50)
        self.rect(self.l_margin, self.get_y(), self.w - self.l_margin - self.r_margin, 2, style="F")
        self.ln(4)
        self.set_font("F", "B", 16)
        self.set_text_color(50, 50, 50)
        self.cell(0, 7, "MoonPathfinding 项目申报书", align="C", new_x="LMARGIN", new_y="NEXT")
        self.set_font("F", "", 8)
        self.set_text_color(130, 120, 105)
        self.cell(0, 5, "2026 MoonBit 国产开源生态竞赛（个人赛）", align="C", new_x="LMARGIN", new_y="NEXT")
        self.ln(2)

    def sec(self, num, title):
        self.ln(1)
        self.set_font("F", "B", 10)
        self.set_text_color(50, 50, 50)
        self.cell(0, 5, f"{num}、{title}", new_x="LMARGIN", new_y="NEXT")
        self.set_draw_color(50, 50, 50)
        self.set_line_width(0.2)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(1.5)

    def body(self, text):
        self.set_font("F", "", 7.5)
        self.set_text_color(55, 55, 55)
        self.multi_cell(0, 3.8, text, align="L")

    def bullet(self, text):
        self.set_font("F", "", 7)
        self.set_text_color(65, 65, 65)
        self.cell(3, 3.6, "")
        self.cell(0, 3.6, "- " + text, new_x="LMARGIN", new_y="NEXT")

    def info(self, label, value):
        self.set_font("F", "B", 7.5)
        self.set_text_color(60, 60, 60)
        self.cell(28, 4.2, label + "：")
        self.set_font("F", "", 7.5)
        self.set_text_color(50, 50, 50)
        self.cell(0, 4.2, value, new_x="LMARGIN", new_y="NEXT")

    def sub(self, title):
        self.set_font("F", "B", 8)
        self.set_text_color(50, 50, 50)
        self.cell(0, 4.5, title, new_x="LMARGIN", new_y="NEXT")

    def t_header(self, cells, widths):
        self.set_fill_color(50, 50, 50)
        self.set_text_color(255, 255, 255)
        self.set_font("F", "B", 7)
        h = 5
        for cell, w in zip(cells, widths):
            x = self.get_x()
            self.rect(x, self.get_y(), w, h, style="F")
            self.cell(w, h, " " + cell)
        self.ln(h)

    def t_row(self, cells, widths, bold=False):
        if bold:
            self.set_fill_color(235, 235, 235)
            self.set_font("F", "B", 7)
        else:
            self.set_fill_color(255, 255, 255)
            self.set_font("F", "", 7)
        self.set_text_color(50, 50, 50)
        h = 4.8
        for cell, w in zip(cells, widths):
            x = self.get_x()
            self.rect(x, self.get_y(), w, h, style="DF")
            self.cell(w, h, " " + cell)
        self.ln(h)


pdf = PDF()
pdf.set_auto_page_break(auto=False)
pdf.add_page()

pdf.title_line()

# ===== 一 =====
pdf.sec("一", "基本信息")
pdf.info("项目名称", "MoonPathfinding：MoonBit 路径查找算法库")
pdf.info("GitHub", "https://github.com/hzc-666-ai/MoonPathfinding-MoonBit")
pdf.info("GitLink", "https://gitlink.org.cn/hzc666/moonpathfinding")
pdf.info("项目方向", "MoonBit 基础库 / 图算法与路径规划")
pdf.info("移植参考", "原创设计，参考 A*/JPS/Dijkstra 等经典算法｜许可证：MIT")

# ===== 二 =====
pdf.sec("二", "项目简介")
pdf.body(
    "MoonPathfinding 是一个纯 MoonBit 实现的路径查找算法库，提供 9 种算法、5 种图类型、"
    "3 种迷宫生成器以及 ASCII/HTML 可视化。"
    "MoonBit 生态中目前没有路径查找/图搜索相关库，本项目填补空白，"
    "所有实现纯 MoonBit 代码，零外部依赖，基于 Graph trait 泛型设计，用户可自定义图类型。"
)

# ===== 三 =====
pdf.sec("三", "核心功能")

pdf.sub("9 种算法（791行）")
for item in [
    "无信息搜索: BFS(广度优先) / DFS(深度优先) / Dijkstra(加权最短) / Bellman-Ford(支持负权)",
    "有信息搜索: A*(f=g+h) / Greedy BFS(仅启发) / IDA*(迭代加深, 内存高效)",
    "网格优化: Bidirectional BFS(双端搜索) / JPS(跳点搜索, 大规模网格上比A*快数十倍)",
]:
    pdf.bullet(item)

pdf.sub("5 种图类型（379行）| 3 种迷宫生成器（181行）| ASCII/HTML 可视化（90行）")
for item in [
    "AdjacencyList(通用有向/无向图) | Grid(4方向网格) | WeightedGrid(8方向+地形代价)",
    "HexGrid(六边形网格 odd-q布局) | Graph trait(用户可自定义图类型, 即插即用)",
    "DFS递归回溯(狭长走廊) | Prim算法(多分支短死路) | 随机障碍物",
    "ASCII终端渲染(S/*/E/#字符画) | HTML表格导出(CSS样式, 可浏览器查看)",
]:
    pdf.bullet(item)

# ===== 四 =====
pdf.sec("四", "差异化价值")

pdf.body("算法对比表：")
pdf.t_header(["算法", "类型", "最优路径", "加权图", "特点"], [22, 22, 20, 20, 42])
for row in [
    ("BFS", "无信息", "是(无权)", "否", "队列"),
    ("DFS", "无信息", "否", "否", "栈"),
    ("Dijkstra", "无信息", "是", "是", "优先队列"),
    ("A*", "有信息", "是", "是", "f=g+h"),
    ("Greedy BFS", "有信息", "否", "是", "f=h"),
    ("Bidir BFS", "无信息", "是(无权)", "否", "双端"),
    ("Bellman-Ford", "无信息", "是", "是(含负权)", "DP"),
    ("IDA*", "有信息", "是", "是", "省内存"),
    ("JPS", "有信息", "是", "均匀网格", "跳点剪枝"),
]:
    pdf.t_row(row, [22, 22, 20, 20, 42])

pdf.body(
    "MoonBit 生态中无等价路径查找库。基于 Graph trait 的泛型设计支持任意图类型，"
    "5种内置图类型覆盖常见场景，迷宫生成器+可视化让答辩演示直观。"
)

# ===== 五 =====
pdf.sec("五", "项目规模与进度")

pdf.t_header(["模块", "源码行", "测试行", "测试数"], [50, 24, 24, 24])
for row in [
    ("algo (9算法+MinHeap)", "791", "204", "26"),
    ("graph (5图类型+trait)", "379", "272", "20"),
    ("maze (3生成器)", "181", "41", "5"),
    ("bench (性能对比)", "162", "-", "-"),
    ("visualize (可视化)", "90", "15", "3"),
    ("cmd/main (CLI)", "60", "-", "-"),
    ("顶层集成测试", "-", "129", "8"),
    ("配置/文档", "27", "-", "-"),
    ("合计", "1,690", "661", "62"),
]:
    pdf.t_row(row, [50, 24, 24, 24], bold=(row[0] == "合计"))
pdf.ln(1)

pdf.body(
    "总计 2,351 行，62 测试全通过，CI 已配置。已完成全部 9 算法、5 图类型、"
    "可视化及 Benchmark 模块。"
)

# ===== 六 =====
pdf.sec("六", "适用场景")
pdf.body(
    "游戏 NPC / AI 寻路 | 机器人路径规划 | 物流配送路径优化 | 地图导航系统 | "
    "算法教学与可视化演示 | MoonBit 生态图算法基础设施 | "
    "基于 Graph trait 的泛型编程教学范例"
)

output_path = os.path.join(os.path.dirname(__file__), "MoonPathfinding项目申报书.pdf")
pdf.output(output_path)
print(f"Done: {output_path}")
