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
pdf.info("发布模块", "hzc-666-ai/moonpathfinding @ 0.1.3")
pdf.info("GitHub", "https://github.com/hzc-666-ai/MoonPathfinding-MoonBit")
pdf.info("GitLink", "https://gitlink.org.cn/hzc666/moonpathfinding")
pdf.info("方向/性质", "MoonBit 图算法基础库｜原创实现｜MIT 许可证")

# ===== 二 =====
pdf.sec("二", "项目简介")
pdf.body(
    "MoonPathfinding 是纯 MoonBit 实现的路径查找算法库，面向游戏寻路、网格路径规划、"
    "加权图路线计算和算法教学。项目提供 9 种算法、Graph trait 与 4 种具体图结构、"
    "3 种迷宫生成器、路径工具、Benchmark 以及 ASCII/HTML 可视化。"
)

# ===== 三 =====
pdf.sec("三", "核心功能")

pdf.sub("算法与路径工具（1,160行）")
for item in [
    "8种 Graph 通用算法: BFS / DFS / Dijkstra / Bellman-Ford / A* / Greedy / IDA* / 双向BFS",
    "Grid专用JPS: 八方向均匀代价网格跳点剪枝 | 路径工具: 平滑 / 简化 / 展开 / 抽稀",
]:
    pdf.bullet(item)

pdf.sub("图抽象（458行）| 迷宫生成器（180行）| 可视化（123行）")
for item in [
    "AdjacencyList(通用有向/无向图) | Grid(4方向网格) | WeightedGrid(8方向+地形代价)",
    "HexGrid(六边形网格 odd-q布局) | Graph trait(供8种通用算法扩展图实现)",
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
    ("Dijkstra", "无信息", "非负权", "是", "优先队列"),
    ("A*", "有信息", "可采纳启发", "是", "f=g+h"),
    ("Greedy BFS", "有信息", "否", "是", "f=h"),
    ("Bidir BFS", "无信息", "是(无权)", "否", "双端"),
    ("Bellman-Ford", "无信息", "无负环", "是(含负权)", "逐边松弛"),
    ("IDA*", "有信息", "可采纳启发", "是", "省内存"),
    ("JPS", "有信息", "适用网格", "均匀网格", "跳点剪枝"),
]:
    pdf.t_row(row, [22, 22, 20, 20, 42])

pdf.body(
    "8种通用算法复用 Graph trait，JPS 保留明确的 Grid 适用边界。"
    "Bellman-Ford 负权/负环、有向图双向BFS、Greedy完整代价和JPS连续路径均有严格测试。"
)

# ===== 五 =====
pdf.sec("五", "项目规模与进度")

pdf.t_header(["模块", "源码行", "测试行"], [76, 25, 25])
for row in [
    ("algo (9算法+路径工具)", "1,160", "343"),
    ("graph (trait+4具体图)", "458", "196"),
    ("maze (3生成器)", "180", "45"),
    ("bench (性能对比)", "260", "-"),
    ("visualize (可视化)", "123", "24"),
    ("cmd/main (CLI)", "63", "-"),
    ("顶层库/集成测试", "18", "149"),
    ("合计", "2,262", "757"),
]:
    pdf.t_row(row, [76, 25, 25], bold=(row[0] == "合计"))
pdf.ln(1)

pdf.body(
    "MoonBit 合计 3,019 行（源码2,262 + 测试757），74个测试在 wasm/wasm-gc/JS/native "
    "四后端通过；CI 含 check/fmt/info/test，当前23次提交。"
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
