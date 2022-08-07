# Awesome R 中文版(ZH_CN)

[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

这里有很多非常不错的R包和工具. 该想法来自于[awesome-machine-learning](https://github.com/josephmisiti/awesome-machine-learning).

这里是包的导航清单，看起来更方便 https://awesome-r.com

<img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20"> 
for [Top 50](https://github.com/rstudio/RStartHere/blob/master/top_downloads_2016/top_packages) CRAN downloaded packages or repos with 400+ 
<img class="emoji" alt="star" src="https://awesome-r.com/star.png" height="20" align="absmiddle" width="20">


- [Awesome R](#awesome-)
    - [集成开发环境](#integrated-development-environments)
    - [语法](#syntax)
    - [数据操作](#data-manipulation)
    - [图形显示](#graphic-displays)
    - [HTML部件](#html-widgets)
    - [复用组件研究](#reproducible-research)
    - [Web技术和服务](#web-technologies-and-services)
    - [并行计算](#parallel-computing)
    - [高性能](#high-performance)
    - [语言API](#language-api)
    - [数据库管理](#database-management)
    - [机器学习](#machine-learning)
    - [自然语言处理](#natural-language-processing)
    - [贝叶斯](#bayesian)
    - [最优化](#optimization)
    - [金融](#finance)
    - [生物信息学](#bioinformatics)
    - [网络分析](#network-analysis)
    - [R 开发](#r-development)
    - [日志](#logging)
    - [数据包](#data-packages)
    - [其他工具](#other-tools)
    - [其他编译器](#other-interpreters)
    - [R学习](#learning-r)
- [资源](#resources)
    - [网站](#websites)
    - [书籍](#books)
    - [博客](#podcasts)
    - [参考文献](#reference-cards)
    - [网络课程](#moocs)
    - [列表](#lists)
- [其他Awesome列表](#other-awesome-lists)
- [贡献](#contributing)

## Integrated Development Environments
*集成开发环境* 

* [RStudio <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://www.rstudio.org/) - 一个非常强大高效的图形界面开发环境，可以在Windows, Mac, 和Linux运行.
* [Emacs + ESS](http://ess.r-project.org/) - ESS是一个emacs文本编辑器的一个统计分析的插件.
* [Sublime Text + R-Box](http://github.com/randy3k/R-Box/) - 一个在Sublime 2/3中使用R语言编程的插件.
* [TextMate + r.tmblundle](https://github.com/textmate/r.tmbundle) - TextMate 1/2的插件.
* [StatET](http://www.walware.de/goto/statet) - 一个基于Eclipse的R语言IDE.
* [Revolution R Enterprise](http://www.revolutionanalytics.com/get-revolution-r-enterprise) - 专注于大数据,大规模多处理器的功能,可以对学术用户免费提供和商业使用.
* [R Commander](http://socserv.mcmaster.ca/jfox/Misc/Rcmdr/) - 一个包括基本图形用户界面的R包.
* [IRkernel <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/IRkernel/IRkernel) - Jupyter的R语言内核.
* [Deducer](http://www.deducer.org/pmwiki/pmwiki.php?n=Main.DeducerManual?from=Main.HomePage) - 一个菜单驱动的数据分析的GUI工具,类似电子表格数据编辑器.
* [Radiant](http://vnijs.github.io/radiant/) - 一个使用R语言，独立的基于浏览器接口的业务分析平台,基于Shiny。
* [Vim-R](https://github.com/vim-scripts/Vim-R-plugin) - Vim中R语言插件. 
* [Nvim-R](https://github.com/jalvesaq/Nvim-R) - Neovim中R语言插件.
* [JASP](https://jasp-stats.org/) - 一个完整的贝叶斯和概念论相关方法的R包,和使用SPSS非常相似。
* [Bio7](http://www.bio7.org/) - 一个包括创建,科学图像分析和统计分析的IDE.
* [RTVS](http://microsoft.github.io/RTVS-docs/) - Visual Studio中R开发工具.

## Syntax
*改变你使用R方式的包*

* [magrittr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/smbache/magrittr) - 一个R语言高效的管道操作包.
* [pipeR](https://github.com/renkun-ken/pipeR) - 多泛型管道的实现.
* [lambda.r](https://github.com/zatonovo/lambda.r) - R语言中函数式编程和简单的模式匹配.
* [purrr](https://github.com/hadley/purrr) - 一个高级函数编程语言包.

## Data Manipulation
*数据处理相关的包*

* [dplyr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/dplyr) - 快速数据操作和数据库查询.
* [data.table <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/Rdatatable/data.table) - 使用短小灵活的语法操作数据.
* [reshape2  <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/reshape) - 灵活的数据排列,聚合处理.
* [readr](https://github.com/hadley/readr) - 一个快速简单的读取表格数据到R中的包.
* [haven](https://github.com/hadley/haven) - 对导入SPSS,STATA和SAS的文件进行改进.
* [tidyr](https://github.com/hadley/tidyr) - 方便对数据进行整理、传播和收集.
* [broom](https://github.com/dgrtwo/broom) - 将统计分析对象转换成整齐的数据框(一种数据组织和呈现的方式).
* [rlist](https://github.com/renkun-ken/rlist) - 一个操作非规范化数据的工具箱.
* [jsonlite](https://github.com/jeroenooms/jsonlite) - 一个快速解析JSON文件的包.
* [ff](http://ff.r-forge.r-project.org/) - 设计用来存储大型数据集的数据结构.
* [lubridate](http://cran.r-project.org/web/packages/lubridate/index.html) - 一组日期和时间函数.
* [stringi <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://www.rexamine.com/resources/stringi/) - 基于ICU的字符串处理方案.
* [stringr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/stringr) - 基于stringi之上的对字符串处理API.
* [bigmemory](http://cran.r-project.org/web/packages/bigmemory/index.html) - 提供共享内存和内存映射矩阵,同时也包提供额外的工具,包括线性模型.([biglm](http://cran.r-project.org/web/packages/biglm/index.html)) 和随机森林 ([bigrf](https://github.com/aloysius-lim/bigrf)).
* [fuzzyjoin](https://github.com/dgrtwo/fuzzyjoin) - 使用不精确匹配的方式连接表数据.
* [tidyverse](https://github.com/hadley/tidyverse) - 简单从tidyverse下载和安装包.

## Graphic Displays
*Packages for showing data.*

* [ggplot2 <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/ggplot2) - 强大的绘图统计和计算图形系统的实现.强烈推荐.
* [ggfortify](https://github.com/sinhrks/ggfortify) -一个ggplot2(流行的统计软件包)统一的接口(使用一行代码即可).A unified interface to ggplot2 popular statistical packages using one line of code.
* [ggrepel](https://github.com/slowkow/ggrepel) - 排除重叠的文本标签.
* [ggalt](https://github.com/hrbrmstr/ggalt) - ggplot2额外的坐标系统,几何和统计.
* [ggtree](https://github.com/GuangchuangYu/ggtree) - 可视化和注释的系统树.
* [ggplot2 Extensions](https://ggplot2-exts.github.io/ggiraph.html) - ggplot2扩展显示例子.
* [lattice](http://lattice.r-forge.r-project.org/) - 一个强大优雅的高级数据可视化系统.
* [corrplot](https://github.com/taiyun/corrplot) - 图形显示相关矩阵或一般矩阵。它还包含一些矩阵重新排序算法.
* [rgl](http://cran.r-project.org/web/packages/rgl/index.html) - R中3D可视化系统.
* [Cairo](http://cran.r-project.org/web/packages/Cairo/index.html) - 一个使用cairo组件创建高质量显示输出的R图形包.
* [extrafont](https://github.com/wch/extrafont) - 在R中图像中使用字体的工具.
* [showtext](https://github.com/yixuan/showtext) - 让R图形设备显示文本的时候使用系统字体.
* [animation](http://yihui.name/animation/) - 一个使用 [ImageMagick](http://imagemagick.org/)在R中产生动画图形的工具.
* [gganimate](https://github.com/dgrtwo/gganimate) - 用ggplot2创建简单的动画.
* [misc3d](https://cran.r-project.org/web/packages/misc3d/index.html) - 强大的3D绘图工具.
* [xkcd](https://cran.r-project.org/web/packages/xkcd/index.html) - 在图表中使用xkcd风格.
* [imager](http://dahtah.github.io/imager/) - 一个基于CImg库的图像处理包.

## HTML Widgets
*Packages for interactive visualizations.*

* [d3heatmap](https://github.com/rstudio/d3heatmap) - 使用D3绘制互动的热图.
* [DataTables](http://rstudio.github.io/DT/) - 将R矩阵或数据框作为交互的HTML表
* [DiagrammeR <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/rich-iannone/DiagrammeR) - 在R中创建JS图表和流程图.
* [dygraphs](https://github.com/rstudio/dygraphs) - 在R中绘制时间序列数据图形.
* [formattable](http://renkun.me/formattable/) - 可格式化的数据结构.
* [ggvis](https://github.com/rstudio/ggvis) - R中交互式的图形处理语法.
* [Leaflet](http://rstudio.github.io/leaflet/) - 一个非常流行的交互式地图JavaScript组件.
* [MetricsGraphics](http://hrbrmstr.github.io/metricsgraphics/) - 可以轻松创建D3散点图、折线图和直方图.
* [networkD3](http://christophergandrud.github.io/networkD3/) - D3 JavaScriptR网络图.
* [scatterD3](https://github.com/juba/scatterD3) - D3 互动散点图.
* [plotly <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/ropensci/plotly) - 使用[plot.ly](https://plot.ly)进行交互式ggplot2和Shiny绘图.
* [rCharts <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/ramnathv/rCharts) - 交互式JS绘图.
* [rbokeh](http://hafen.github.io/rbokeh/) - [Bokeh](http://bokeh.pydata.org/en/latest/)的R接口.
* [threejs](https://github.com/bwlewis/rthreejs) - 交互式3D散点图和地球仪.
* [timevis](https://github.com/daattali/timevis) - 创建完全交互式的时间轴可视化图形.
* [visNetwork](https://github.com/datastorm-open/visNetwork) - 使用vis.js类库进行网络可视化.

## Reproducible Research
*Packages for literate programming.*

* [knitr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://yihui.name/knitr/) - R中简单的动态报表生成工具.
* [xtable](http://cran.r-project.org/web/packages/xtable/index.html) - 将表格导出到LaTeX或者HTML.
* [rapport](http://rapport-package.info/#intro) - 一个R模版系统.
* [rmarkdown <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://rmarkdown.rstudio.com/) - R动态文档工具.
* [slidify](https://github.com/ramnathv/slidify) - 创建和发布漂亮的html5展示效果.
* [Sweave](https://www.statistik.lmu.de/~leisch/Sweave/) - 使用R创建LaTeX报表的R包.
* [texreg](http://www.philipleifeld.de/software/texreg/texreg.html) - 在LaTex和HTML中格式化统计模型.
* [checkpoint](https://github.com/RevolutionAnalytics/checkpoint) - 从检查点快照服务器安装包.
* [brew](https://cran.r-project.org/web/packages/brew/index.html) - 报告模板的生成框架.可以和knitr合并.
* [ReporteRs](http://davidgohel.github.io/ReporteRs/index.html) - 一个生成微软Word, PowerPoint和HTML报表的R包.
* [bookdown](https://bookdown.org/) - 使用R Markdown编写书籍.
* [ezknitr](https://github.com/daattali/ezknitr) - 避免使用'knitr'带来的工作目录的痛苦.

## Web Technologies and Services
*Packages to surf the web.*

* [Web Technologies List](https://github.com/ropensci/webservices) - 关于如何使用R和网络的相关信息.
* [shiny <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/rstudio/shiny) - 使用R创建简单的Web交互应用.
* [RCurl](http://cran.r-project.org/web/packages/RCurl/index.html) - 常规的网络客户端接口 (HTTP/FTP/...) .
* [httr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/httr) - 使用更加友好的RCurl封装.
* [httpuv](https://github.com/rstudio/httpuv) - HTTP和WebSocket服务程序.
* [XML <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/XML/index.html) - R中生成和解析XML的工具.
* [rvest <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/rvest) - 简单的web信息抓取,使用CSSSelect 和 XPath 语法.
* [OpenCPU <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://www.opencpu.org/) - HTTP API.
* [Rfacebook](https://github.com/pablobarbera/Rfacebook) - Facebook API.
* [RSiteCatalyst](https://github.com/randyzwitch/RSiteCatalyst) - Adobe 分析服务的R语言客户端.
* [plumber](https://github.com/trestletech/plumber) - 一个将现有的R代码转换为API的包.

## Parallel Computing
*Packages for parallel computing.*

* [parallel](http://cran.r-project.org/web/views/HighPerformanceComputing.html) - R语言高性能的并行计算平台. [multicore](http://cran.r-project.org/web/packages/multicore/index.html) and [snow](http://cran.r-project.org/web/packages/snow/index.html).
* [Rmpi](http://cran.r-project.org/web/packages/Rmpi/index.html) - Rmpi对MPI APIS提供了一个包装过的接口,它也提供一个交互式的R环境.
* [foreach <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/foreach/index.html) - 使用并行来执行循环.
* [SparkR <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/amplab-extras/SparkR-pkg) - R for Spark.
* [DistributedR](https://github.com/vertica/DistributedR) - 一个来自惠普Vertica Analytics团队的可伸缩的高性能平台.
* [ddR](https://github.com/vertica/ddR) - 提供分布式数据结构,简化了R中的分布式计算.
* [sparklyr](http://spark.rstudio.com/) - 来自RStudio的Spark接口.

## High Performance
*Packages for making R faster.*

* [Rcpp <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://rcpp.org/) - Rcpp在R中提供了一个高效的API,使得函数更快执行.
* [Rcpp11](https://github.com/Rcpp11/Rcpp11) - Rcpp11完全重新设计,以C++11为目标.
* [compiler](http://stat.ethz.ch/R-manual/R-devel/library/compiler/html/compile.html) - 使用JIT提高R代码的速度.

## Language API
*Packages for other languages.*

* [rJava](http://cran.r-project.org/web/packages/rJava/) - R语言对JAVE接口.
* [jvmr](https://github.com/cran/jvmr) - 集成了R, Java, and Scala.
* [rJython](http://cran.r-project.org/web/packages/rJython/index.html) - R语言对Python/Jython的接口.
* [rPython](http://cran.r-project.org/web/packages/rPython/index.html) - 允许R调用Python.
* [runr](https://github.com/yihui/runr) - 在R中运行Julia和Bash.
* [RJulia](https://github.com/armgong/RJulia) - R中调用Julia.
* [RinRuby](https://sites.google.com/a/ddahl.org/rinruby-users/) - 一个Ruby库,整合了R用Ruby解释器.
* [R.matlab](http://cran.r-project.org/web/packages/R.matlab/index.html) - 读写mat文件,将R和Matlab连接到一起.
* [RcppOctave](https://github.com/renozao/RcppOctave) -Octave and Matlab的接口.
* [RSPerl](http://www.omegahat.org/RSPerl/) - 双向接口,R中调用Perl和在Perl中调用R.
* [V8](https://github.com/jeroenooms/V8) - 嵌入JavaScript引擎.
* [htmlwidgets](http://www.htmlwidgets.org/) - R中把JavaScript数据可视化的最好方法.
* [rpy2](http://rpy.sourceforge.net/) - Python对R的接口.

## Database Management
*Packages for managing data.*

* [RODBC](http://cran.r-project.org/web/packages/RODBC/) - R中ODBC数据库范围.
* [DBI](https://github.com/rstats-db/DBI) - 在R和数据库管理系统之间定义一个公共的接口.
* [elastic](https://github.com/ropensci/elastic) - Elasticsearch HTTP API的包装器.
* [mongolite](https://github.com/jeroenooms/mongolite) - R中Mongo客户端.
* [RMySQL](http://cran.r-project.org/web/packages/RMySQL/) - R语言的MySQL数据库接口.
* [ROracle](http://cran.r-project.org/web/packages/ROracle/index.html) - R中Oracle数据库的接口.
* [RPostgreSQL](https://code.google.com/p/rpostgresql/) - R语言的PostgreSQL数据库系统接口.
* [RSQLite](http://cran.r-project.org/web/packages/RSQLite/) - R语言SQLite数据库接口.
* [RJDBC](http://cran.r-project.org/web/packages/RJDBC/) - 通过JDBC接口访问数据库.
* [rmongodb](https://github.com/mongosoup/rmongodb) - R中MongoDB驱动.
* [rredis](http://cran.r-project.org/web/packages/rredis/) - R中Redis驱动.
* [RCassandra](http://cran.r-project.org/web/packages/RCassandra/index.html) -Apache Cassanda直接接口(不是JAVA)，提供了最多的基本功能.
* [RHive](https://github.com/nexr/RHive) - 通过Apache Hive的R扩展促进分布式计算.
* [RNeo4j](https://github.com/nicolewhite/Rneo4j) - Neo4j图形数据库驱动.

## Machine Learning
*Packages for making R cleverer.*

* [AnomalyDetection <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/twitter/AnomalyDetection) - 来自Twitter的AnomalyDetection R包.
* [ahaz](http://cran.r-project.org/web/packages/ahaz/index.html) - 半参数添加风险回归的正则化.
* [arules](http://cran.r-project.org/web/packages/arules/index.html) - 挖掘关联规则和频繁项集.
* [bigrf](http://cran.r-project.org/web/packages/bigrf/index.html) - 大随机森林:大型数据集的分类和回归森林.
* [bigRR](http://cran.r-project.org/web/packages/bigRR/index.html) - 广义回归(特殊是在p >> n情况下).
* [bmrm](http://cran.r-project.org/web/packages/bmrm/index.html) - 风险最小化方案的正规化方法.
* [Boruta](http://cran.r-project.org/web/packages/Boruta/index.html) - 所有相关的特征选择算法的一个封装
* [BreakoutDetection](https://github.com/twitter/BreakoutDetection) - Breakout Detection via Robust E-Statistics from Twitter.[暂时不明真相]
* [bst](http://cran.r-project.org/web/packages/bst/index.html) - 梯度增加.
* [CausalImpact](https://github.com/google/CausalImpact) - 利用贝叶斯时间序列结构模型进行因果推断.
* [C50](http://cran.r-project.org/web/packages/C50/index.html) - C5.0决策树和基于规则的模型.
* [caret <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/caret/index.html) - 分类和回归训练.
* [Clever Algorithms For Machine Learning](https://github.com/jbrownlee/CleverAlgorithmsMachineLearning)
* [CORElearn](http://cran.r-project.org/web/packages/CORElearn/index.html) - 分类、回归、特征评价和排序.
* [CoxBoost](http://cran.r-project.org/web/packages/CoxBoost/index.html) - Cox models by likelihood based boosting for a single survival endpoint or competing risks.
* [Cubist](http://cran.r-project.org/web/packages/Cubist/index.html) - 规则和基于实例的回归建模
* [e1071](http://cran.r-project.org/web/packages/e1071/index.html) - Misc统计函数 (e1071),主要功能有类别分析、傅里叶变换,模糊聚类,支持向量机,最短路径计算,朴素贝叶斯分类器等等.
* [earth](http://cran.r-project.org/web/packages/earth/index.html) - 多元自适应回归模型.
* [elasticnet](http://cran.r-project.org/web/packages/elasticnet/index.html) - 稀疏估计和稀疏主成分分析.
* [ElemStatLearn](http://cran.r-project.org/web/packages/ElemStatLearn/index.html) - 书籍"The Elements of Statistical Learning, Data Mining, Inference, and Prediction"中的数据集,函数和例子.
* [evtree](http://cran.r-project.org/web/packages/evtree/index.html) - 全局最优树的进化学习.
* [forecast](http://cran.r-project.org/web/packages/forecast/index.html) - 使用ARIMA, ETS, STLM, TBATS,和神经网络进行时间序列预测.
* [forecastHybrid](http://cran.r-project.org/web/packages/forecastHybrid/index.html) - 使用"forecast"包对ARIMA, ETS, STLM, TBATS,和神经网络模型进行交叉检验.
* [FSelector](https://cran.r-project.org/web/packages/FSelector/index.html) - 一个基于subset-search或特性排名方法的特征选择框架.
* [frbs](http://cran.r-project.org/web/packages/frbs/index.html) - 使用模糊规则系统处理分类和回归的任务.
* [GAMBoost](http://cran.r-project.org/web/packages/GAMBoost/index.html) -　　基于广义线性和加法模型.
* [gamboostLSS](http://cran.r-project.org/web/packages/gamboostLSS/index.html) - GAMLSS方法的改善.
* [gbm](http://cran.r-project.org/web/packages/gbm/index.html) - 改善广义线性模型.
* [glmnet <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/glmnet/index.html) - Lasso 和 elastic-net正规化广义线性模型.
* [glmpath](http://cran.r-project.org/web/packages/glmpath/index.html) - L1 Regularization Path for Generalized Linear Models and Cox
Proportional Hazards Model
* [GMMBoost](http://cran.r-project.org/web/packages/GMMBoost/index.html) - 广义混合模型.
* [grplasso](http://cran.r-project.org/web/packages/grplasso/index.html) - Fitting user specified models with Group Lasso penalty
* [grpreg](http://cran.r-project.org/web/packages/grpreg/index.html) - Regularization paths for regression models with grouped
covariates.
* [h2o <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/h2o/index.html) - Deeplearning, Random forests, GBM, KMeans, PCA, GLM
* [hda](http://cran.r-project.org/web/packages/hda/index.html) - 异方差判别分析.
* [ipred](http://cran.r-project.org/web/packages/ipred/index.html) - 预测器改进.
* [kernlab](http://cran.r-project.org/web/packages/kernlab/index.html) - kernlab: 基于内核学习的机器实验室.
* [klaR](http://cran.r-project.org/web/packages/klaR/index.html) - 分类和可视化.
* [kohonen](http://cran.r-project.org/web/packages/kohonen/) - 监督和非监督自组织映射.
* [lars](http://cran.r-project.org/web/packages/lars/index.html) - Least Angle Regression, Lasso and Forward Stagewise
* [lasso2](http://cran.r-project.org/web/packages/lasso2/index.html) - L1 constrained estimation aka ‘lasso’
* [LiblineaR](http://cran.r-project.org/web/packages/LiblineaR/index.html) - 基于C/C++库的线性预测模型.
* [lme4 <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/lme4/lme4) - Mixed-effects models 
* [LogicReg](http://cran.r-project.org/web/packages/LogicReg/index.html) - 逻辑回归模型.
* [maptree](http://cran.r-project.org/web/packages/maptree/index.html) - 映射、修剪和图形树模型.
* [mboost](http://cran.r-project.org/web/packages/mboost/index.html) - Model-Based Boosting
* [Machine Learning For Hackers](https://github.com/johnmyleswhite/ML_for_Hackers)
* [mvpart](http://cran.r-project.org/web/packages/mvpart/index.html) - Multivariate partitioning
* [MXNet <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/dmlc/mxnet/tree/master/R-package) - MXNet brings flexible and efficient GPU computing and state-of-art deep learning to R.
* [ncvreg](http://cran.r-project.org/web/packages/ncvreg/index.html) - Regularization paths for SCAD- and MCP-penalized regression
models
* [nnet](http://cran.r-project.org/web/packages/nnet/index.html) - eed-forward Neural Networks and Multinomial Log-Linear Models
* [oblique.tree](http://cran.r-project.org/web/packages/oblique.tree/index.html) - Oblique Trees for Classification Data
* [pamr](http://cran.r-project.org/web/packages/pamr/index.html) - Pam: 小矩阵预测分析.
* [party](http://cran.r-project.org/web/packages/party/index.html) - A Laboratory for Recursive Partytioning
* [partykit](http://cran.r-project.org/web/packages/partykit/index.html) - A Toolkit for Recursive Partytioning
* [penalized](http://cran.r-project.org/web/packages/penalized/index.html) - L1 (lasso and fused lasso) and L2 (ridge) penalized estimation
in GLMs and in the Cox model
* [penalizedLDA](http://cran.r-project.org/web/packages/penalizedLDA/index.html) - Penalized classification using Fisher's linear discriminant
* [penalizedSVM](http://cran.r-project.org/web/packages/penalizedSVM/index.html) - 使用惩罚函数的特征选择支持向量机.
* [quantregForest](http://cran.r-project.org/web/packages/quantregForest/index.html) - quantregForest: Quantile Regression Forests
* [randomForest](http://cran.r-project.org/web/packages/randomForest/index.html) - 随机森林: Breiman and Cutler's random forests for classification and regression.
* [randomForestSRC](http://cran.r-project.org/web/packages/randomForestSRC/index.html) - randomForestSRC: Random Forests for Survival, Regression and Classification (RF-SRC).
* [rattle](http://cran.r-project.org/web/packages/rattle/index.html) - 图形界面式的数据挖掘工具.
* [rda](http://cran.r-project.org/web/packages/rda/index.html) - Shrunken Centroids Regularized Discriminant Analysis
* [rdetools](http://cran.r-project.org/web/packages/rdetools/index.html) - Relevant Dimension Estimation (RDE) in Feature Spaces
* [REEMtree](http://cran.r-project.org/web/packages/REEMtree/index.html) - Regression Trees with Random Effects for Longitudinal (Panel)
Data
* [relaxo](http://cran.r-project.org/web/packages/relaxo/index.html) - Relaxed Lasso
* [rgenoud](http://cran.r-project.org/web/packages/rgenoud/index.html) - R version of GENetic Optimization Using Derivatives
* [rgp](http://cran.r-project.org/web/packages/rgp/index.html) - R基因编程框架.
* [Rmalschains](http://cran.r-project.org/web/packages/Rmalschains/index.html) - 使用本地文化基因算法进行连续问题优化.[这里翻译不准].
Search Chains (MA-LS-Chains) in R
* [rminer](http://cran.r-project.org/web/packages/rminer/index.html) - 在分类和回归问题中简单的使用数据挖掘方法(如神经网络和支持向量机).
* [ROCR](http://cran.r-project.org/web/packages/ROCR/index.html) - 可视化评分分类器的性能.
* [RoughSets](http://cran.r-project.org/web/packages/RoughSets/index.html) - 使用粗糙集和模糊粗糙集理论进行数据分析.
* [rpart](http://cran.r-project.org/web/packages/rpart/index.html) - Recursive Partitioning and Regression Trees
* [RPMM](http://cran.r-project.org/web/packages/RPMM/index.html) - Recursively Partitioned Mixture Model
* [RSNNS](http://cran.r-project.org/web/packages/RSNNS/index.html) - Neural Networks in R using the Stuttgart Neural Network
Simulator (SNNS)
* [Rsomoclu](https://cran.r-project.org/web/packages/Rsomoclu/index.html) - Parallel implementation of self-organizing maps.
* [RWeka](http://cran.r-project.org/web/packages/RWeka/index.html) - Weka的R接口(Weka是基于JAVA环境下开源的机器学习以及数据挖掘软件).
* [RXshrink](http://cran.r-project.org/web/packages/RXshrink/index.html) - RXshrink: Maximum Likelihood Shrinkage via Generalized Ridge or Least
Angle Regression
* [sda](http://cran.r-project.org/web/packages/sda/index.html) - Shrinkage Discriminant Analysis and CAT Score Variable Selection
* [SDDA](http://cran.r-project.org/web/packages/SDDA/index.html) - Stepwise Diagonal Discriminant Analysis
* [SuperLearner](https://github.com/ecpolley/SuperLearner) and [subsemble](http://cran.r-project.org/web/packages/subsemble/index.html) - Multi-algorithm ensemble learning packages.
* [svmpath](http://cran.r-project.org/web/packages/svmpath/index.html) - svmpath: the SVM Path algorithm
* [tgp](http://cran.r-project.org/web/packages/tgp/index.html) - Bayesian treed Gaussian process models
* [tree](http://cran.r-project.org/web/packages/tree/index.html) - 分类和回归树.
* [varSelRF](http://cran.r-project.org/web/packages/varSelRF/index.html) - 使用随机森林进行变量选择.
* [xgboost <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/tqchen/xgboost/tree/master/R-package) - eXtreme Gradient Boosting Tree model, well known for its speed and performance.

## Natural Language Processing
*Packages for Natural Language Processing.*

* [text2vec](https://github.com/dselivanov/text2vec) - 一个快速文本挖掘框架。
 Fast Text Mining Framework for Vectorization and Word Embeddings.
* [tm](http://cran.r-project.org/web/packages/tm/index.html) - 一个全面的文本挖掘框架.
* [openNLP](http://cran.r-project.org/web/packages/openNLP/index.html) - Apache OpenNLP工具接口.
* [koRpus](http://cran.r-project.org/web/packages/koRpus/index.html) - 一个文本分析的R包.
* [zipfR](http://cran.r-project.org/web/packages/zipfR/index.html) - 词频分布统计模型.
* [NLP](http://cran.r-project.org/web/packages/NLP/index.html) - 基本自然语言处理功能.
* [LDAvis](https://github.com/cpsievert/LDAvis) - 主题模型的交互式可视化.
* [topicmodels](https://cran.r-project.org/web/packages/topicmodels/index.html) - Topic modeling interface to the C code developed by by David M. Blei for Topic Modeling (Latent Dirichlet Allocation (LDA), and Correlated Topics Models (CTM)).
* [syuzhet](https://cran.r-project.org/web/packages/syuzhet/index.html) - Extracts sentiment from text using three different sentiment dictionaries.
* [SnowballC](https://cran.rstudio.com/web/packages/SnowballC/index.html) - Snowball stemmers based on the C libstemmer UTF-8 library.
* [quanteda](https://github.com/kbenoit/quanteda) - 文本数据的定量分析.
* [Topic Models Resources](https://github.com/trinker/topicmodels_learning) - 主题模型的学习和R相关资源.
* [NLP for <img src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f1e8-1f1f3.png" width="20" heigth="20" align="absmiddle" class="emoji" alt=":cn:">](https://github.com/BZRLC/R-notes/blob/master/NLP/readme.md) - NLP related resources in R. @Chinese

## Bayesian
*Packages for Bayesian Inference.*

* [coda](http://cran.r-project.org/web/packages/coda/index.html) - 输出MCMC(马尔可夫链蒙特卡尔理论)的分析和诊断信息.
* [mcmc](http://cran.r-project.org/web/packages/mcmc/index.html) - 马尔可夫链蒙特卡尔理论(MCMC).
* [MCMCpack](http://mcmcpack.berkeley.edu/) - 马尔可夫链蒙特卡尔理论 (MCMC).
* [R2WinBUGS](http://cran.r-project.org/web/packages/R2WinBUGS/index.html) - 在在R/S-PLUS中打开WinBUGS 和 OpenBUGS.
* [BRugs](http://cran.r-project.org/web/packages/BRugs/index.html) - OpenBUGS MCMC 软件的R接口.
* [rjags](http://cran.r-project.org/web/packages/rjags/index.html) - JAGS MCMC组件的R接口.
* [rstan <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://mc-stan.org/interfaces/rstan.html) - Stan MCMC软件的R接口.

## Optimization
*Packages for Optimization.*

* [minqa](https://cran.rstudio.com/web/packages/minqa/index.html) - Derivative-free optimization algorithms by quadratic approximation.
* [nloptr](https://cran.rstudio.com/web/packages/nloptr/index.html) - 一个免费开源的非线性最优化程序包.
* [lpSolve](https://cran.rstudio.com/web/packages/lpSolve/index.html) - `Lp_solve`解决线性和整形问题的R接口.

## Finance
*Packages for dealing with money.*

* [quantmod <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://www.quantmod.com/) - 定量金融模型和交易框架.
* [TTR](http://cran.r-project.org/web/packages/TTR/index.html) - 技术交易规相关的数据和功能函数.
* [PerformanceAnalytics](http://cran.r-project.org/web/packages/PerformanceAnalytics/index.html) - 计量经济学性能和风险分析工具.
* [zoo <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://cran.r-project.org/web/packages/zoo/index.html) - S3 Infrastructure for Regular and Irregular Time Series.
* [xts](http://cran.r-project.org/web/packages/xts/index.html) - 可扩展的时间序列.
* [tseries](http://cran.r-project.org/web/packages/tseries/index.html) - 金融时间序列分析和计算.
* [fAssets](http://cran.r-project.org/web/packages/fAssets/index.html) - 金融资产分析和建模.

## Bioinformatics
*Packages for processing biological datasets.*

* [Bioconductor <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://www.bioconductor.org/) - 用于分析和理解高通量基因组数据的工具.
* [genetics](http://cran.r-project.org/web/packages/genetics/index.html) - 处理基因数据的R包.
* [gap](http://cran.r-project.org/web/packages/gap/index.html) - 一个人口家庭遗传数据分析的综合工具.
* [ape](http://cran.r-project.org/web/packages/ape/index.html) - 分子系统学和进化分析.
* [pheatmap](http://cran.r-project.org/web/packages/pheatmap/index.html) - 一个使用简单的热图工具.
* [ddpcr](https://github.com/daattali/ddpcr) - Analysis and visualization of Droplet Digital PCR data.

## Network Analysis
*Packages to construct, analyze and visualize network data.*

* [Network Analysis List](https://github.com/briatte/awesome-network-analysis) - 网络分析相关资源.
* [igraph <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://igraph.org/r/) - 一个网络分析工具集合.
* [network](https://cran.r-project.org/web/packages/network/index.html) - 一个操作数据关系的基本工具.
* [sna](https://cran.r-project.org/web/packages/sna/index.html) - 基本的网络测量和可视化工具.
* [netdiffuseR](https://github.com/USCCANA/netdiffuseR) - 网络扩散的分析工具.
* [networkDynamic](https://cran.r-project.org/web/packages/networkDynamic/) - 支持动态和时序网络.
* [ndtv](https://cran.r-project.org/web/packages/ndtv/) - 构建动画的可视化动态网络工具,支持多种数据格式.
* [statnet](http://statnet.org/) - 大量网络数据的分析,仿真和可视化工具.
* [ergm](https://cran.r-project.org/web/packages/ergm/index.html) - 指数随机图模型.
* [latentnet](https://cran.r-project.org/web/packages/latentnet/index.html) - Latent position and cluster models for network objects.
* [tnet](https://cran.r-project.org/web/packages/tnet/index.html) - Network measures for weighted, two-mode and longitudinal networks.
* [rgexf](https://bitbucket.org/gvegayon/rgexf/wiki/Home) - 从R导出网络对象到[GEXF](http://gexf.net/format/), for manipulation with network software like [Gephi](https://gephi.org/) or [Sigma](http://sigmajs.org/).
* [visNetwork](https://github.com/datastorm-open/visNetwork) - 使用vis.js类库进行网络可视化.

## R Development
*Packages for packages.*

* [Package Development List](https://github.com/ropensci/PackageDevelopment) - 提高整体开发能力的包.
* [devtools <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/devtools) - 然R开发人员的生活变得更简单的工具.
* [testthat <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/testthat) - 一个R包测试工具.
* [R6 <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/wch/R6) - simpler, faster, lighter-weight alternative to R's built-in classes.
* [pryr <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/hadley/pryr) - Make it easier to understand what's going on in R.
* [roxygen <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/klutometis/roxygen) - 在函数定义中描述说明.
* [lineprof](https://github.com/hadley/lineprof) - R中在线分析结果可视化.
* [packrat](https://github.com/rstudio/packrat) - 让R项目更加简单,便携和可重构的工具.
* [installr](https://github.com/talgalili/installr/) - R中按照软件的相关函数(Windows平台).
* [import](https://github.com/smbache/import/) - R的导入机制.
* [modules](https://github.com/klmr/modules) - 另外一个R模块系统(Python风格).
* [Rocker <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](https://github.com/rocker-org) - R configurations for [Docker](https://www.docker.com/).
* [RStudio Addins](https://github.com/daattali/rstudio-addins) - RStudio插件列表. 
* [drat](https://github.com/eddelbuettel/drat) - Creation and use of R repositories on 使用R在GitHub或其他平台创建和使用仓储.
* [covr](https://github.com/jimhester/covr) - Test coverage for your R package and (optionally) upload the results to [coveralls](https://coveralls.io/) or [codecov](https://codecov.io/).
* [lintr](https://github.com/jimhester/lintr) - R静态代码分析.
* [staticdocs](https://github.com/hadley/staticdocs) - 为一个R包生成静态html文档.

## Logging
*Packages for Logging*

* [futile.logger](https://github.com/zatonovo/futile.logger) - R中类似log4j的日志记录包.
* [log4r](https://github.com/johnmyleswhite/log4r) - R中的log4j接口
* [logging](https://cran.r-project.org/web/packages/logging/index.html) - 一个在R中实现log4j的日志处理包.

## Data Packages
*Handy Data Packages*

* [engsoccerdata](https://github.com/jalapic/engsoccerdata) - 英国和欧洲联赛结果数据(1871-2016年).
* [gapminder](http://github.com/jennybc/gapminder) - 从Gapminder摘录的数据集.

## Other Tools
*Handy Tools for R*

* [git2r](https://github.com/ropensci/git2r) - 在R中使用git.

## Other Interpreters
*Alternative R engines.*

* [CXXR](https://www.cs.kent.ac.uk/projects/cxxr/) - Refactorising R into C++.
* [fastR](https://bitbucket.org/allr/fastr/wiki/Home) - FastR is an implementation of the R Language in Java atop Truffle and Graal.
* [incanter](https://github.com/incanter/incanter) - Clojure-based, R-like statistical computing and graphics environment for the JVM with Lisp spirit.
* [pqR](http://www.pqr-project.org/) - 一个更快的R实现.
* [renjin](http://www.renjin.org/) - 一个基于JVM的R编译器.
* [rho](https://github.com/rho-devel/rho) - Refactor the interpreter of the R language into a fully-compatible, efficient, VM for R.
* [riposte](https://github.com/jtalbot/riposte) - 一个R快速编译和JIT工具.
* [RRO](https://mran.revolutionanalytics.com/open/) - R革命性开放平台(Microsoft R Open).
* [TERR](http://spotfire.tibco.com/discover-spotfire/what-does-spotfire-do/predictive-analytics/tibco-enterprise-runtime-for-r-terr) - R的TIBCO企业运行环境.


## Learning R
*Packages for Learning R.*

* [swirl](http://swirlstats.com/) - 一个在R控制台中交互式学习指南.
* [DataScienceR](https://github.com/ujjwalkarn/DataScienceR) - 一个数据科学,神经网络,和机器学习的指南.

# Resources

发现新的R资源的地方.

## Websites

* [R-project](http://www.r-project.org/) - R 项目的官方网站.
* [R Bloggers](http://www.r-bloggers.com/) - R语言的一个综合性博客网站.
* [DataCamp](https://www.datacamp.com/) - 在线学习R数据分析.
* [Quick-R](http://www.statmethods.net/) - 一个非常好的快速参考手册.
* [Advanced R <img class="emoji" alt="heart" src="https://awesome-r.com/heart.png" height="20" align="absmiddle" width="20">](http://adv-r.had.co.nz/) - 书籍高级R编程的在线版.
* [Efficient R Programming](https://csgillespie.github.io/efficientR/) - 书籍"Efficient R Programming"的在线主页.
* [CRAN Task Views](http://cran.r-project.org/web/views/) - CRAN包的任务列表.
* [The R Programming Wikibook](https://en.wikibooks.org/wiki/R_Programming) - 一个R协作手册 
* [R-users](https://www.r-users.com/) - R语言的求职板块.
* [R Cookbook](http://www.cookbook-r.com/) - 一个R问答网站,由[R Graphics Cookbook]进行支持(http://shop.oreilly.com/product/0636920023135.do).
* [tryR](http://tryr.codeschool.com/) - 快速开始使用R.
* [RDocumentation](https://www.rdocumentation.org/) - 使用RDocumentation搜索所有的CRAN, Bioconductor, Github包和文档.

## Books

* [R Books List](https://github.com/RomanTsegelskyi/rbooks) - R相关书籍清单.
* [The Art of R Programming](http://shop.oreilly.com/product/9781593273842.do) - 一个很好的资源,可以系统地学习基础类型的对象,控制语句,变量的范围,以及调试等.
* [Free Books](https://cran.r-project.org/other-docs.html) - CRAN贡献的多种语言文档. Contributed Documentation in many languages.
* [R Cookbook](http://shop.oreilly.com/product/9780596809164.do) - 快速简单的介绍R及相关常见的统计任务.
* Johns Hopkins编写的数据科学专业的一部分教程:
  * [Exploratory Data Analysis with R](https://leanpub.com/exdata) - 基本的各种数据分析技能.
  * [R Programming for Data Science](https://leanpub.com/rprogramming) - 依赖于R的一些高级数据分析.
  * [Report Writing for Data Science in R](https://leanpub.com/reportwriting) - R语言的报表生成和可重用组件研究.
* [R Packages](http://r-pkgs.had.co.nz/) - 一个用R包编写的书籍 (有论文和网站2钟格式).
* [R in Action](http://www.manning.com/kabacoff2/) - 一本旨在帮助所有级别R用户的书籍.
* [Use R!](http://www.springer.com/series/6991?detailsPage=titles) - This series of inexpensive and focused books from Springer publish shorter books aimed at practitioners. Books can discuss the use of R in a particular subject area, such as Bayesian networks, ggplot2 and Rcpp.
* [R for SAS and SPSS users](http://r4stats.com/books/free-version/) - 一个对已经熟悉SAS和SPASS用户的资源库.
* [An Introduction to R](https://cran.r-project.org/doc/manuals/R-intro.pdf) - 一个很好的介绍R的文章,也涵盖了一些高级主题.
* [Introduction to Statistical Learning with Application in R](http://www-bcf.usc.edu/~gareth/ISL/) - A simplified and "operational" version of *The Elements of Statistical Learning*. Free softcopy provided by its authors.
* [The R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf) - Patrick Burns gives insight into R's ins and outs along with its quirks!
* [R for Data Science](http://r4ds.had.co.nz/) - Free book from RStudio developers with emphasis on data science workflow.

## Podcasts

* [Not So Standard Deviations](https://soundcloud.com/nssd-podcast) - 数据科学博客 
  * [@Roger Peng](https://twitter.com/rdpeng) and [@Hilary Parker](https://twitter.com/hspter).
* [R World News](http://www.rworld.news/blog/) - R行业的社区新闻,可以让你与时俱进.   
  * [@Bob Rudis](https://twitter.com/hrbrmstr) and [@Jay Jacobs](https://twitter.com/jayjacobs).
* [The R-Podcast](https://r-podcast.org/) - 使用R的一些实践建议.
  * [@Eric Nantz](https://r-podcast.org/stories/contact.html).
* [R Talk](http://rtalk.org) - 关于R语言和统计软件的新闻和讨论. 
  * [@Oliver Keyes](https://twitter.com/quominus), [@Jasmine Dumas](https://twitter.com/jasdumas), [@Ted Hart](https://twitter.com/emhrt_) and [@Mikhail Popov](https://twitter.com/bearloga).

## Reference Cards

* [R Reference Card 2.0](http://cran.r-project.org/doc/contrib/Baggott-refcard-v2.pdf) - Material from R for Beginners by permission of Emmanuel Paradis (Version 2 by Matt Baggott).
* [Regression Analysis Refcard](http://cran.r-project.org/doc/contrib/Ricci-refcard-regression.pdf) - R Reference Card for Regression Analysis.
* [Reference Card for ESS](http://ess.r-project.org/refcard.pdf) - Reference Card for ESS.
* [R Markdown Cheat sheet](http://shiny.rstudio.com/images/rm-cheatsheet.pdf.zip) - Quick reference guide for writing reports with R Markdown.
* [Shiny Cheat sheet](http://shiny.rstudio.com/images/cheatsheet.pdf.zip) - Quick reference guide for building Shiny apps.
* [ggplot2 Cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf) - Quick reference guide for data visualisation with ggplot2.
* [devtools Cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/06/devtools-cheatsheet.pdf) - Quick reference guide to package development in R.

## MOOCs
*Massive open online courses.*

* [The Analytics Edge](https://www.edx.org/course/analytics-edge-mitx-15-071x-0) - Hands-on introduction to data analysis with R from MITx.
* [Johns Hopkins University Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1) - 9 courses including: Introduction to R, literate analysis tools, Shiny and some more.
* [HarvardX Biomedical Data Science](http://simplystatistics.org/2014/11/25/harvardx-biomedical-data-science-open-online-training-curriculum-launches-on-january-19/) - Introduction to R for the Life Sciences.
* [Explore Statistics with R](https://www.edx.org/course/explore-statistics-r-kix-kiexplorx-0) - Covers introduction, data handling and statistical analysis in R.

## Lists
*Great resources for learning domain knowledge.*

* [Books](https://github.com/RomanTsegelskyi/rbooks) - R书籍清单.
* [DataScienceR](https://github.com/ujjwalkarn/DataScienceR) - R数据科学、神经网络和机器学习的指南清单.
* [ggplot2 Extensions](https://ggplot2-exts.github.io/ggiraph.html) - ggplot2扩展案例.
* [Natural Language Processing <img src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f1e8-1f1f3.png" width="20" heigth="20" align="absmiddle" class="emoji" alt=":cn:">](https://github.com/BZRLC/R-notes/blob/master/NLP/readme.md) - R. @Chinese中NLP 相关资源
* [Network Analysis](https://github.com/briatte/awesome-network-analysis) - 网络分析相关资源.
* [Open Data](https://github.com/ropensci/opendata) - 使用R获取,转换,操作,创建和贡献数据.
* [Posts](https://github.com/qinwf/awesome-R/blob/master/posts.md) - 创建R博客或者文章.
* [Package Development](https://github.com/ropensci/PackageDevelopment) - 提高包开发的资源工具.
* [R Project Conferences](https://www.r-project.org/conferences.html) -  使用R的相关信息,DSC会议.
* [RStartHere](https://github.com/rstudio/RStartHere) - 一些非常有用的R包指南.
* [RStudio Addins](https://github.com/daattali/addinslist) - RStudio插件清单.
* [Topic Models](https://github.com/trinker/topicmodels_learning) - 主题模型的学习和R相关资源.
* [Web Technologies](https://github.com/ropensci/webservices) - 如何使用R和万维网的信息.

# Other Awesome Lists

* [awesome-awesomeness](https://github.com/bayandin/awesome-awesomeness)
* [lists](https://github.com/jnv/lists)

# Contributing
一直欢迎大家的贡献!我的邮件:asxinyu@qq.com
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License - [CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)
