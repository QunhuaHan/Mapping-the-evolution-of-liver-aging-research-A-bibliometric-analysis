library(maps)
library(dplyr)
library(sf)
library(ggsci)
library(ggplot2)

map("world")

world <- map_data("world")

a=st_drivers()

#world%>%distinct(region)%>%select(region)%>%filter(grepl("UK", region))
write_xlsx(as.data.frame(result$Countries),"D:\\hqh_sci_cailiao\\20240219_new\\countries.xlsx")

country_tbl=readxl::read_excel("D:\\hqh_sci_cailiao\\20240219_new\\countries.xlsx",sheet=1)
#country_tbl=as.data.frame(result$Countries)
countries_map <- st_read("d://hqh_sci_cailiao//world.zh.json")
#countries_map2 <- st_read("d://hqh_sci_cailiao//world(1).geojson")
head(countries_map)
P_B=ggplot() +
  geom_sf(data = countries_map) +  # 使用 geom_sf 函数绘制地图
  coord_sf(crs = st_crs(countries_map)) +  # 设置坐标参考系统与数据匹配
  theme_minimal()  # 使用简洁的主题样式

merged_df <- left_join(countries_map, country_tbl, by = c("NAME" = "Tab"))

P_B=ggplot() +
  geom_sf(data = merged_df,aes(fill=log(Freq))) +
  theme_classic()+
  theme(
    axis.line = element_blank(), # 移除轴线
    axis.text.x = element_blank(), # 移除X轴刻度标签
    axis.text.y = element_blank(), # 移除Y轴刻度标签
    axis.ticks = element_blank(), # 移除刻度线
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10)
  )+
  scale_fill_distiller(palette = "Spectral")#+
  #scale_color_distiller(palette = "Spectral")+
  #scale_fill_gradient(low = "lightblue", high = "red")+
  #labs(title = "World Countries Map")



# p_a=ggplot() +
#   geom_map(data = country_tbl, aes(map_id=Country,fill=Freq), map=world) +
#   theme_classic()+
#   theme(
#     axis.line = element_blank(), # 移除轴线
#     axis.text.x = element_blank(), # 移除X轴刻度标签
#     axis.text.y = element_blank(), # 移除Y轴刻度标签
#     axis.ticks = element_blank() # 移除刻度线
#   )+
#   scale_fill_gradient(low = "lightblue", high = "red")+
#   geom_path(data=world,aes(x=long,y=lat,group=group),colour="black",size=0.2)+
#   coord_cartesian()

ggsave(filename = "D:\\hqh_sci_cailiao\\20240219_new\\p3_country_map_new6_3111.pdf", # 指定要保存的文件名和扩展名
       plot = P_B,                  # ggplot对象，可以省略，默认会保存最后绘制的图
       width = 210,           # 图像宽度（单位：英寸）
       height = 105,          # 图像高度（单位：英寸）
       device = "pdf",
       units ="mm")             # 可选，指定设备类型（如png、pdf、jpeg等），默认根据文件扩展名自动判断
