import 'package:easy_refresh_flutter3/easy_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food/pages/detail.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../data.dart';
import '../untils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int currentIndex = 0;

  List dataList = [];

  //顶部横向滚动列表的分类项
  List<String> titles = ["美食", "食品", "日用", "花植", "保健"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 20; i++) {
      Map map = {
        'id': dataList.length + 1,
        'name': Data[i % Data.length]["name"],
        'pirce': Data[i % Data.length]["pirce"],
        'url': Data[i % Data.length]["url"],
        'mealType': Data[i % Data.length]["mealType"],
        'isCollect': Data[i % Data.length]["isCollect"],
      };
      dataList.add(map);
    }
    print(dataList);
    tabController = TabController(length: titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //顶部横向滚动的分类列表
            TabBar(
                labelColor: Colors.red[800],
                unselectedLabelColor: Colors.red[400],
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                controller: tabController,
                tabs: titles.map((e) => Tab(text: e)).toList()),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: titles
                  .map((e) => TabBarWidget(
                        title: e,
                        data: dataList,
                      ))
                  .toList(),
            ))
          ],
        ),
      ),
    );
  }
}

class TabBarWidget extends StatefulWidget {
  final String title;
  final List data;

  const TabBarWidget({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  // final RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  List dataList = [];

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = List.from(widget.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //用来获取屏幕宽高
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        return EasyRefresh(
          controller: _controller,
          //下拉刷新
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2)).then((value) {
              dataList = [];
              setList();
              if (mounted) {
                setState(() {});
              }
              _controller.finishRefresh();
              _controller.resetFooter();
            });
          },
          //上拉加载
          onLoad: () async {
            await Future.delayed(const Duration(seconds: 2)).then((value) {
              setList();
              if (mounted) {
                setState(() {});
              }
              _controller.finishLoad(IndicatorResult.succeeded);
            });
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(dataList.length, (index) {
                      //用屏幕的宽，计算每一个项的宽的大小
                      //内容区域是一个特殊样式（一排个数为2-1-2-1-2...卡片)
                      //通过索引的方式来算
                      //如果 % 3 == 0 那么则是第三个，宽度是全屏，其他的宽度是一半
                      double width = (index + 1) % 3 == 0
                          ? boxConstraints.maxWidth
                          : (boxConstraints.maxWidth - padding * 3) / 2;
                      var data = dataList[index];
                      return SizedBox(
                        width: width,
                        child: Card(
                          elevation: 3,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(padding)),
                          child: Container(
                              child: (index + 1) % 3 == 0
                                  ? Row(
                                      children: [
                                        Image.asset(
                                          data["url"],
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: width / 2,
                                        ),
                                        Expanded(
                                          child: _buildData(data),
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Image.asset(
                                          data["url"],
                                          fit: BoxFit.cover,
                                          height: 130,
                                        ),
                                        const SizedBox(
                                          height: padding,
                                        ),
                                        _buildData(data),
                                      ],
                                    )),
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void setList() {
    //一次取20条数据
    for (int i = 0; i < 20; i++) {
      Map map = {
        'id': dataList.length + 1,
        'name': Data[i % Data.length]["name"],
        'pirce': Data[i % Data.length]["pirce"],
        'url': Data[i % Data.length]["url"],
        'mealType': Data[i % Data.length]["mealType"],
        'isCollect': Data[i % Data.length]["isCollect"],
      };
      dataList.add(map);
    }
  }

  Column _buildData(data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data["name"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 20,
            ),
            Text("¥${data["pirce"]}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[800])),
          ],
        ),
        const SizedBox(
          height: padding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding / 4),
          child: Row(
            children: lunchString
                .map((e) => Expanded(
                        child: Text(
                      e,
                      style: TextStyle(
                          color: e == data["mealType"]
                              ? Colors.red[300]
                              : Colors.grey[400]),
                    )))
                .toList(),
          ),
        ),
        const SizedBox(
          height: padding,
        ),
        GestureDetector(
            onTap: () async {
              //点击进入到详情页面
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(
                            data: data,
                          ))).then((value) => setState(() {
                    //返回后更新是否在详情页面点击收藏按钮
                    data["isCollect"] = value;
                  }));
            },
            //收藏后返回列表时刷新'收藏至礼品库'变为'已收藏'
            child:
                data["isCollect"] ? const Text("已收藏") : const Text("收藏至礼品库")),
        const SizedBox(
          height: padding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              const Text("用礼金兑换", style: TextStyle(color: Colors.green)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: padding / 2, vertical: padding / 3),
                decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(10)),
                child: Text("送给TA", style: TextStyle(color: Colors.red[800])),
              )
            ],
          ),
        ),
        const SizedBox(
          height: padding,
        ),
      ],
    );
  }
}
