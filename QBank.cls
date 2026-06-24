% QBank.cls - 题库文档类
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{QBank}[2024/12/19 QBank Document Class]

% 基础类
\LoadClass[UTF8]{ctexbook}

% ===== 必需包 =====
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{graphicx}
\RequirePackage[titles]{tocloft}
\RequirePackage{hyperref}
\RequirePackage{geometry} 
\RequirePackage{caption}
\RequirePackage{fancyhdr}
\RequirePackage{emptypage}
\RequirePackage{wrapfig}
\RequirePackage{pdfpages}
\RequirePackage{eso-pic}
\RequirePackage{atbegshi}
\RequirePackage{import}
\RequirePackage{everyshi}
\RequirePackage{subcaption}
\RequirePackage{microtype}
\RequirePackage{titlesec}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{float}
\RequirePackage{multirow}
\RequirePackage{tikz}
\RequirePackage{everypage}
\RequirePackage{xparse}
\RequirePackage{zhnumber}
\RequirePackage{etoolbox}
\RequirePackage{zref}

% ===== 页面设置 =====
\geometry{a4paper,left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm}

% ===== 字体和排版优化 =====
\setmainfont{Times New Roman}
\setCJKmainfont{Songti SC}[AutoFakeBold=true]
\microtypesetup{expansion=false}

% ===== 图片环境设置 =====
\setlength{\intextsep}{12pt plus 2pt minus 2pt}
\setlength{\columnsep}{12pt}

% 子图编号格式
\renewcommand{\thesubfigure}{(\alph{subfigure})}
\captionsetup[subfigure]{labelformat=simple, labelsep=space}

% 一行多个图片的简单命令
\newcommand{\doublefigure}[6]{%
    \begin{figure}[H]
        \centering
        \begin{subfigure}[b]{0.48\textwidth}
            \centering
            \includegraphics[width=#1\textwidth]{#2}
            \caption*{#3}
        \end{subfigure}
        \hfill
        \begin{subfigure}[b]{0.48\textwidth}
            \centering
            \includegraphics[width=#4\textwidth]{#5}
            \caption*{#6}
        \end{subfigure}
    \end{figure}
}

\newcommand{\triplefigure}[9]{%
    \begin{figure}[H]
        \centering
        \begin{subfigure}[b]{0.32\textwidth}
            \centering
            \includegraphics[width=#1\textwidth]{#2}
            \caption*{#3}
        \end{subfigure}
        \hfill
        \begin{subfigure}[b]{0.32\textwidth}
            \centering
            \includegraphics[width=#4\textwidth]{#5}
            \caption*{#6}
        \end{subfigure}
        \hfill
        \begin{subfigure}[b]{0.32\textwidth}
            \centering
            \includegraphics[width=#7\textwidth]{#8}
            \caption*{#9}
        \end{subfigure}
    \end{figure}
}

% ===== 章节格式自定义 =====
\titleformat{\chapter}[display]
{\normalfont\huge\bfseries\filcenter}
{\chaptertitlename\ \thechapter}{20pt}{\Huge}

\titleformat{\section}
{\normalfont\Large\bfseries}
{\thesection}{1em}{}

\titleformat{\subsection}
{\normalfont\large\bfseries}
{\thesubsection}{1em}{}

\titlespacing*{\chapter}{0pt}{-30pt}{40pt}
\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}
\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}

% ===== 附录章节格式 =====
\titleformat{name=\chapter,numberless}[display]
{\normalfont\huge\bfseries\filcenter}
{}{0pt}{\Huge}

% ===== 主计数器定义 =====
\newcounter{problem}[chapter]
\newcounter{subproblem}[problem]
\newcounter{subsubproblem}[subproblem]
\newcounter{subsubsubproblem}[subsubproblem]
\newcounter{subsubsubsubproblem}[subsubsubproblem]

\newcounter{solution}[problem]
\newcounter{subsolution}
\newcounter{subsubsolution}
\newcounter{subsubsubsolution}
\newcounter{subsubsubsubsolution}

% ===== 编号格式 =====
\renewcommand{\theproblem}{\thechapter.\arabic{problem}}
\renewcommand{\thesubproblem}{\arabic{subproblem}}
\renewcommand{\thesubsubproblem}{\thesubproblem.\arabic{subsubproblem}}
\renewcommand{\thesubsubsubproblem}{\thesubsubproblem.\arabic{subsubsubproblem}}
\renewcommand{\thesubsubsubsubproblem}{\thesubsubsubproblem.\arabic{subsubsubsubproblem}}

\renewcommand{\thesolution}{\arabic{solution}}
\renewcommand{\thesubsolution}{\arabic{subsolution}}
\renewcommand{\thesubsubsolution}{\arabic{subsubsolution}}
\renewcommand{\thesubsubsubsolution}{\arabic{subsubsubsolution}}
\renewcommand{\thesubsubsubsubsolution}{\arabic{subsubsubsubsolution}}

% ===== 全新的方程计数器系统 =====
% 全局方程计数器 - 用于实际计数
\newcounter{global@equation}

% 环境状态跟踪
\newif\ifinproblem
\newif\ifinsolution

% 创建环境专用计数器存储
\newcommand{\create@env@equation@counter}[3]{%
    \@ifundefined{c@#1@equation@#2@#3}{%
        \newcounter{#1@equation@#2@#3}%
        \setcounter{#1@equation@#2@#3}{0}%
    }{}%
}

% 设置环境方程编号
\newcommand{\setup@env@equations}[3]{%
    \create@env@equation@counter{#1}{#2}{#3}%
    \setcounter{global@equation}{\value{#1@equation@#2@#3}}%
    \ifinproblem
        \renewcommand{\theequation}{\theproblem.\arabic{global@equation}.p}%
    \else
        \renewcommand{\theequation}{\theproblem.\arabic{global@equation}.s}%
    \fi
}

% 保存环境方程计数器
\newcommand{\save@env@equations}[3]{%
    \setcounter{#1@equation@#2@#3}{\value{global@equation}}%
}

% 恢复默认方程编号
\newcommand{\restore@default@equation}{%
    \renewcommand{\theequation}{\thechapter.\arabic{global@equation}}%
}

% 重定义 equation 环境以确保正确递增计数器
\let\oldequation\equation
\let\endoldequation\endequation
\renewenvironment{equation}{%
    \ifinproblem
        \refstepcounter{global@equation}%
        \oldequation%
    \else
        \ifinsolution
            \refstepcounter{global@equation}%
            \oldequation%
        \else
            \refstepcounter{global@equation}%
            \oldequation%
        \fi
    \fi
}{%
    \endoldequation%
}

% 重定义 eqnarray 环境
\let\oldeqnarray\eqnarray
\let\endoldeqnarray\endeqnarray
\renewenvironment{eqnarray}{%
    \ifinproblem
        \refstepcounter{global@equation}%
        \oldeqnarray%
    \else
        \ifinsolution
            \refstepcounter{global@equation}%
            \oldeqnarray%
        \else
            \refstepcounter{global@equation}%
            \oldeqnarray%
        \fi
    \fi
}{%
    \endoldeqnarray%
}

% ===== 问题环境 =====
\NewDocumentEnvironment{problem}{O{} O{} m}{%
    \refstepcounter{problem}%
    \setcounter{subproblem}{0}%
    \setcounter{solution}{0}%
    \inproblemtrue%
    \insolutionfalse%
    
    % 设置problem环境的方程编号
    \setup@env@equations{problem}{\arabic{chapter}}{\arabic{problem}@p}%
    
    \addcontentsline{toc}{subsection}{Problem \theproblem\ #2}%
    \vspace{1.5ex}%
    \par\noindent\textbf{\large Problem \theproblem. }%
    \if\relax\detokenize{#1}\relax\else\ \textbf{(#1)}\fi%
    \textbf{#2}%
    \vspace{0.5ex}%
    \par\ignorespaces%
}{%
    % 保存problem环境的方程计数器
    \save@env@equations{problem}{\arabic{chapter}}{\arabic{problem}@p}%
    % 恢复默认方程编号
    \restore@default@equation%
    \inproblemfalse%
    \par\vspace{2.5em}%
}

\newenvironment{subproblem}[1][]{%
    \refstepcounter{subproblem}%
    \setcounter{subsubproblem}{0}%
    \vspace{0.5ex}%
    \par\noindent\hspace{1em}\textbf{(\thesubproblem)} #1%
    \vspace{0.3ex}%
    \ignorespaces%
}{}

\newenvironment{subsubproblem}[1][]{%
    \refstepcounter{subsubproblem}%
    \setcounter{subsubsubproblem}{0}%
    \vspace{0.3ex}%
    \par\noindent\hspace{2em}\textbf{(\thesubsubproblem)} #1%
    \vspace{0.2ex}%
    \ignorespaces%
}{}

\newenvironment{subsubsubproblem}[1][]{%
    \refstepcounter{subsubsubproblem}%
    \setcounter{subsubsubsubproblem}{0}%
    \vspace{0.2ex}%
    \par\noindent\hspace{3em}\textbf{(\thesubsubsubproblem)} #1%
    \ignorespaces%
}{}

\newenvironment{subsubsubsubproblem}[1][]{%
    \refstepcounter{subsubsubsubproblem}%
    \vspace{0.1ex}%
    \par\noindent\hspace{4em}\textbf{(\thesubsubsubsubproblem)} #1%
    \ignorespaces%
}{}

% ===== 解答环境 =====
\NewDocumentEnvironment{solution}{m}{%
    \refstepcounter{solution}%
    \setcounter{subsolution}{0}%
    \inproblemfalse%
    \insolutiontrue%
    
    % 设置solution环境的方程编号
    \setup@env@equations{problem}{\arabic{chapter}}{\arabic{problem}@s}%
    
    \vspace{1.5ex}%
    \par\noindent\textbf{\large Solution \theproblem}%
    \vspace{0.8ex}%
    \par\ignorespaces%
}{%
    % 保存solution环境的方程计数器
    \save@env@equations{problem}{\arabic{chapter}}{\arabic{problem}@s}%
    % 恢复默认方程编号
    \restore@default@equation%
    \insolutionfalse%
    \par\vspace{2em}%
}

\newenvironment{subsolution}[1][]{%
    \refstepcounter{subsolution}%
    \setcounter{subsubsolution}{0}%
    \vspace{0.8ex}%
    \par\noindent\hspace{1.5em}\textbf{(\thesubsolution)} #1%
    \vspace{0.5ex}%
    \ignorespaces%
}{}

\newenvironment{subsubsolution}[1][]{%
    \refstepcounter{subsubsolution}%
    \setcounter{subsubsubsolution}{0}%
    \vspace{0.5ex}%
    \par\noindent\hspace{2.5em}\textbf{(\thesubsolution.\thesubsubsolution)} #1%
    \vspace{0.3ex}%
    \ignorespaces%
}{}

\newenvironment{subsubsubsolution}[1][]{%
    \refstepcounter{subsubsubsolution}%
    \setcounter{subsubsubsubsolution}{0}%
    \vspace{0.3ex}%
    \par\noindent\hspace{3.5em}\textbf{(\thesubsolution.\thesubsubsolution.\thesubsubsubsolution)} #1%
    \ignorespaces%
}{}

\newenvironment{subsubsubsubsolution}[1][]{%
    \refstepcounter{subsubsubsubsolution}%
    \vspace{0.2ex}%
    \par\noindent\hspace{4.5em}\textbf{(\thesubsolution.\thesubsubsolution.\thesubsubsubsolution.\thesubsubsubsubsolution)} #1%
    \ignorespaces%
}{}

% ===== 封面设计 =====
\renewcommand{\title}[1]{%
    \gdef\@title{%
        \vspace*{2cm}%
        \textbf{\fontsize{36pt}{40pt}\selectfont #1}\\[0.5cm]%
        \fontsize{18pt}{20pt}\selectfont A Treasury of Challenging Problems\\[2cm]%
    }%
}

\renewcommand{\author}[1]{%
    \gdef\@author{%
        \fontsize{14pt}{16pt}\selectfont%
        \textbf{沈桓震}\quad \textbf{马天翼}\\[0.3cm]%
        \fontsize{12pt}{14pt}\selectfont%
        \textbf{编著}%
    }%
}

\renewcommand{\date}[1]{%
    \gdef\@date{%
        \vspace{1cm}%
        \fontsize{12pt}{14pt}\selectfont%
        #1%
    }%
}

% ===== 页眉页脚设置 =====
\pagestyle{fancy}
\fancyhf{}

\fancyhead[LE]{\thepage}
\fancyhead[RE]{\leftmark}
\fancyhead[LO]{\leftmark}
\fancyhead[RO]{\thepage}

\renewcommand{\headrulewidth}{0.7pt}

\newlength{\headruleextendleft}
\newlength{\headruleextendright}
\setlength{\headruleextendleft}{-0.5cm}
\setlength{\headruleextendright}{-4.5cm}

\renewcommand{\headrule}{%
  \hspace*{\headruleextendleft}%
  \rule[0.7\baselineskip]{\dimexpr\paperwidth-\headruleextendleft+\headruleextendright\relax}{\headrulewidth}%
  \vspace{-\headrulewidth}%
}

% 设置章节标记格式
\renewcommand{\chaptermark}[1]{\markboth{第\zhnumber{\thechapter}章\quad #1}{}}

% ===== 页码控制 =====
\newcounter{romansave}

\renewcommand{\frontmatter}{%
    \cleardoublepage%
    \pagenumbering{roman}%
    \setcounter{page}{1}%
}

\renewcommand{\mainmatter}{%
    \cleardoublepage%
    \pagenumbering{arabic}%
    \setcounter{page}{1}%
}

\renewcommand{\backmatter}{%
    \cleardoublepage%
    \pagenumbering{roman}%
}

% ===== 附录设置 =====
\let\oldappendix\appendix
\renewcommand{\appendix}{%
    \oldappendix%
    \renewcommand{\chaptermark}[1]{\markboth{附录\thechapter\quad ##1}{}}%
    \renewcommand{\theproblem}{\Alph{chapter}.\arabic{problem}}%
    \renewcommand{\theequation}{\Alph{chapter}.\arabic{global@equation}}%
}

% ===== 目录格式优化 =====
\renewcommand{\cftchapfont}{\normalfont\bfseries}
\renewcommand{\cftsecfont}{\normalfont}
\renewcommand{\cftsubsecfont}{\normalfont}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\setlength{\cftbeforechapskip}{0.5ex}

% ===== 初始化 =====
\AtBeginDocument{%
    \restore@default@equation%
}

% 默认值
\title{难题集萃}
\author{}
\date{\today}