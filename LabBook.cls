\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{LabBook}[2021/12/10]
\LoadClass[onecolumn, twoside, 14pt]{extbook}

%========================================================================================================
%
%										Геометрія сторінки
%
%========================================================================================================
\newlength{\topspace}
\setlength{\topspace}{2cm}
\RequirePackage[%
	a4paper,%
	footskip=1cm,%
	headsep=0.3cm,%
	top=\topspace, %поле сверху
	bottom=2cm, %поле снизу
	left=2cm, %поле ліворуч
	right=2cm, %поле праворуч
]{geometry}

%========================================================================================================
%
%										Налаштування мови та компіляторів
%
%========================================================================================================

\RequirePackage{fontspec}
\RequirePackage[activate={true,nocompatibility},final,tracking=true]{microtype}
\setsansfont{CMU Sans Serif}%{Arial}
\setmainfont{stix}%{CMU Serif}%{Times New Roman}
\setmonofont{CMU Typewriter Text}%{Consolas}
\defaultfontfeatures{Ligatures={TeX}}
\RequirePackage{lualatex-math}
\RequirePackage{amsmath}
\RequirePackage[math-style=TeX,bold-style=TeX]{unicode-math}
\setmathfont[]{Stix Two Math}
\RequirePackage{luacolor}
\RequirePackage[english,russian,ukrainian]{babel}


%========================================================================================================
%
%										Налаштування типографських вимог
%
%========================================================================================================

\setlength{\parindent}{2.5em}%
\def\@textbottom{\vskip \z@ \@plus 1pt}
\let\@texttop\relax


%========================================================================================================
%
%										Пакети
%
%========================================================================================================

\RequirePackage[overload]{textcase}
\let\MakeUppercase\MakeTextUppercase
\RequirePackage{indentfirst}
% ------------------------------------ Плаваючі об'єкти -------------------------------------------------
\RequirePackage{wrapfig}
\RequirePackage[final]{pdfpages}
% ------------------------------------ Таблиці ----------------------------------------------------------
\RequirePackage{subcaption}
\RequirePackage{makecell}
\RequirePackage{array,ragged2e}
\setlength\arrayrulewidth{1pt}
\RequirePackage{booktabs}
\RequirePackage{tabularray}
\newcolumntype{R}{>{\footnotesize}r}
\newcolumntype{L}{>{\footnotesize}l}
\newcolumntype{C}{>{\centering\arraybackslash}p{5em}}
\newcolumntype{M}[1]{>{\begin{varwidth}[t]{#1}}l<{\end{varwidth}}}
\newcommand{\centercell}[1]{\multicolumn{1}{c}{#1}}
% ------------------------------------ Математика -------------------------------------------------------
\let\nfrac\nicefrac
\allowdisplaybreaks
% -------------------------------- Визначення математичних команд -----------------------------------

\AtBeginDocument{%
	\let\phi\varphi
	\let\epsilon\varepsilon
	\DeclareMathOperator{\const}{const}
	\newcommand{\sn}{\sum\limits_{i = 1}^n}
	\newcommand{\average}[1]{\left\langle #1 \right\rangle}
}
\def\eff{e\kern-.3ex f\kern-.5ex f}

%========================================================================================================
%
%										Файлові операції
%
%========================================================================================================
\RequirePackage{currfile}
\RequirePackage{minted}
%========================================================================================================
%
%										Рисування
%
%========================================================================================================
\RequirePackage[most, many]{tcolorbox}
\tcbset{highlight math style={enhanced, colframe=red,
			colback=white,arc=0pt,boxrule=1pt}}
\tcbset{colframe=black,colback=white,colupper=black,
	fonttitle=\bfseries,nobeforeafter,center title,size=small,box align=base}
\newtcolorbox{More}[2][]{
	fontupper=\small,
	parbox=false,
	breakable,
	top=10pt,
	lower separated=false,
	colback=gray!10,
	colframe=white, fonttitle=\bfseries,
	colbacktitle=gray!15,
	coltitle=black,
	enhanced,
	attach boxed title to top left={xshift=0.5cm,yshift=-4mm},
	title={#2},#1}

\newtcolorbox{Warning}[1][]{
	top=10pt,
	before upper={\parindent15pt},
	enhanced jigsaw,breakable,
	fontupper=\small,
	lower separated=false,
	colback=white!80!red,
	colframe=red, fonttitle=\bfseries,
	colbacktitle=white!50!red,
	coltitle=white,
	enhanced,
	attach boxed title to top left={xshift=0.5cm,yshift=-1mm},
	title=Увага}

\newtcolorbox{Definition}[1][]{
	fontupper=\small,
	parbox=false,
	breakable,
	top=10pt,
	lower separated=false,
	colback=gray!10,
	colframe=white, fonttitle=\bfseries,
	colbacktitle=gray!15,
	coltitle=black,
	enhanced,
	attach boxed title to top left={xshift=0.5cm,yshift=-4mm},
	title=Формулювання,#1}

\newtcolorbox{Example}[1][]{
	top=10pt,
	lower separated=false,
	colback=white!80!red,
	colframe=white, fonttitle=\bfseries,
	colbacktitle=white!50!red,
	coltitle=black,
	enhanced,
	attach boxed title to top left={xshift=0.5cm,yshift=-1mm},
	title=Example,#1}

%========================================================================================================
%
%										Рисування
%
%========================================================================================================

\RequirePackage{tikz}
\usetikzlibrary{fpu}
\newcommand{\fputrue}{\pgfkeys{/pgf/fpu=true}}
\newcommand{\fpufalse}{\pgfkeys{/pgf/fpu=false}}
\RequirePackage{pgfplots, pgfplotstable}
\pgfplotsset{compat=newest}
\newcommand{\getelement}[4]{
	\pgfplotstablegetelem{#2}{#3}\of#1
	\pgfmathsetmacro{#4}{\pgfplotsretval}
}
\pgfplotsset{%
	LabPlotGrid/.style={%
			legend cell align=left,
			legend pos=north west,
			legend style={font=\small},
			grid = both,
			grid style={line width=.1pt, draw=brown!10},
			major grid style={line width=.2pt,draw=brown!50},
			minor tick num = 4,
			minor grid style = {line width=.1pt,draw=brown!10},
			tick label style = {font=\sffamily},
			every axis label = {font=sffamily},
			legend style = {font=\sffamily},
			%    label style = {font=\sffamily}
			%    axis x discontinuity=crunch,
			%    axis y discontinuity=crunch,
		},
}

\pgfplotsset{%
	InfoPlotGrid/.style={%
			axis lines = left,
			extra tick style={% changes for all extra ticks
					%						tick align=outside,
					major grid style={dashed,draw=red}
				},
			extra x tick style={
					major tick style={
							gray,
						},
					tick label style={
							/pgf/number format/.cd, fixed, fixed zerofill,
							precision=2,
						}
				},
			extra y tick style={% changes for extra y ticks
					major tick style={
							gray,
						},
				},
			xtick = \empty,
			xmajorgrids=true,
			ymajorgrids=true,
			every axis x label/.style={at={(current axis.right of origin)},anchor=north},
		},
}

\pgfset{
	declare function = {
			gauss(\m,\s,\x) = 1/(sqrt(2*pi)*\s)*exp(-0.5*(\x-\m)^2/\s^2);
			%                    valuegauss(\x,\m,\s) = 1/(sqrt(2*pi)*\s)*exp(-0.5*(\x-\m)^2/\s^2);
		},
}

%========================================================================================================
%
%									      Налаштування для титульних сторінок
%
%========================================================================================================

\ExplSyntaxOn
\RenewDocumentCommand{\title}{m}
{
	\tl_gset:cn { @title } { #1 } % needed by \maketitle
	\tl_gset:Nn { \realtitle } { #1 }
	%  \seq_set_split:Nnn \l_tmpa_seq { \\ } { #1 }
	%  \tl_gset:Nx \inlinetitle { \seq_use:Nn \l_tmpa_seq { ~ } }
}
\ExplSyntaxOff


%========================================================================================================
%
%										   Рубрикація
%
%========================================================================================================

\let\cleardoublepage\clearpage

\RequirePackage[pagestyles]{titlesec}
\RequirePackage[dotinlabels]{titletoc}

\titleformat{\chapter}[display]
{\normalfont\bfseries\filcenter}{\large\thechapter}{1ex}
{\titlerule[2pt]\vspace{2ex}}[\vspace{1ex}{\titlerule[2pt]}]

\titleformat{\section}
{\normalfont\normalsize\bfseries}{\thesection.}{1em}{}

\titleformat{\subsection}
{\normalfont\normalsize\bfseries}{\thesubsection.}{1em}{}

\newpagestyle{main}{%
	\headrule\sethead{\hfill\small \thechapter. \chaptertitle\hfill}{}{}
	\setfoot{}{\small\thepage}{}}

\newpagestyle{addition}{%
	\headrule\sethead{\hfill\small Додатки\hfill}{}{}
	\setfoot{}{\small\thepage}{}}

\titlecontents{chapter}% level to be modified
[0pt]{\addvspace{10pt}}%
{\bfseries\thecontentslabel. }
{}% for star chapters
{\titlerule*[1pc]{.}\contentspage}

%========================================================================================================
%
%										   Відступи
%
%========================================================================================================
\RequirePackage[inline]{enumitem}
\setlength{\aboverulesep}{0pt}
\setlength{\belowrulesep}{0pt}
\setlength{\extrarowheight}{0.75ex}
\RequirePackage[justification=centering,labelsep=period]{caption}
\setlist{
	nolistsep,
	listparindent=\parindent,
	parsep=0pt
}
% ------------------------------------------------ Відступи в формулах ----------------------------------

\setlength\abovedisplayskip{1ex}
\setlength\belowdisplayskip{1ex}
\setlength\abovedisplayshortskip{1ex}
\setlength\belowdisplayshortskip{1ex}

% ----------------------------------------- Відступ між написом та рисунком -----------------------------

\setlength{\textfloatsep}{5pt}

% ---------------------------------------- Підписи до рисунку (розмір тексту) ---------------------------

\captionsetup[figure]{font=small,labelfont=small}
\captionsetup[table]{font=small,labelfont=small}
\captionsetup[listing]{font=small,labelfont=small}

% --------------------------------------------- Bibliography spacing ------------------------------------
\newlength{\bibitemsep}\setlength{\bibitemsep}{.1\baselineskip plus .05\baselineskip minus .05\baselineskip}
\newlength{\bibparskip}\setlength{\bibparskip}{0pt}
\let\oldthebibliography\thebibliography
\renewcommand\thebibliography[1]{%
	\oldthebibliography{#1}%
	\setlength{\parskip}{\bibitemsep}%
	\setlength{\itemsep}{\bibparskip}%
}

%========================================================================================================
%
%									Бібіліографія
%
%========================================================================================================
\RequirePackage[backend=biber, style=numeric-comp, babel=other, isbn=true, url=false, defernumbers=false]{biblatex}
\AtBeginBibliography{\small}
\newbibmacro{string+url}[1]{%
	\iffieldundef{url}{#1}{\href{\thefield{url}}{#1}}%
}
\DeclareFieldFormat{title}{\usebibmacro{string+url}{#1}}
\renewbibmacro*{begentry}{%
	\iffieldundef{note}
	{\undef\bbxnote}
	{\savefield{note}{\bbxnote}%
		\clearfield{note}}}

\renewbibmacro*{finentry}{%
	\restorefield{note}{\bbxnote}%
	\iffieldundef{note}
	{\finentry}
	{%\setunit{\finentrypunct\par\vspace{\bibitemsep}\nobreak}
		\par\textbf{Рекомендується прочитати: }\printfield{note}%
		\finentry}}


%========================================================================================================
%
%										            HYPERREF
%
%========================================================================================================


\RequirePackage[%
	colorlinks = true,
	linkcolor = red!60!black,
	urlcolor  = blue,
	citecolor = green!60!black,
	bookmarks = true,
	bookmarksnumbered=true,
	unicode,
	linktocpage = true,
	hypertexnames=false,
	pdftoolbar=false,
	pdfpagelayout=TwoPageRight,
	pdfauthor={Ponomarenko S.M.},
	pdfdisplaydoctitle=true,
	pdfkeywords={},
	pdfencoding=auto
]%
{hyperref}
\RequirePackage[all]{hypcap}
\RequirePackage{bookmark}

% ------------------------------------ Патч для україомовної назви розділу для nameref ------------------ %
\addto\extrasukrainian{%
	\renewcommand{\chapterautorefname}{}%
}
% ------------------------------------------------------------------------------------------------------- %

\ifdefined\inlinetitle%
	\AtBeginDocument{\hypersetup{pdftitle={\inlinetitle}}}
\fi

\endinput