library(ggplot2)
#TREND TOPICS
file_path <- "D:\\hqh_sci_cailiao\\20240219_new\\keyword plus关键词删除.txt"  # 替换为你的txt文件实际路径
lines_vector <- readLines(file_path)

# 将每一行里的逗号替换成分号
semicolon_separated_lines <- sapply(lines_vector, function(line) {
  gsub(",", ";", line)
})

TREND=fieldByYear(biblio_df,min.freq = 50,n.items = 2,synonyms = synonyms,remove.terms=remove_terms)

ggsave(filename = "D:\\hqh_sci_cailiao\\20240219_new\\trend_topics.pdf", # 指定要保存的文件名和扩展名
       plot = TREND$graph,                  # ggplot对象，可以省略，默认会保存最后绘制的图
       width = 210,           # 图像宽度（单位：英寸）
       height = 150,          # 图像高度（单位：英寸）
       device = "pdf",units = "mm")  

