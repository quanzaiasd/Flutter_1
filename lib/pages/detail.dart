import 'package:flutter/material.dart';
import 'package:flutter_food/untils/constant.dart';

///详情页面
class DetailsPage extends StatefulWidget {
  final Map data;

  const DetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, widget.data["isCollect"]);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.data["name"],
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                widget.data["isCollect"] = !widget.data["isCollect"];
                setState(() {});
              },
              icon: widget.data["isCollect"]
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: padding,
            ),
            Row(
              children: [
                Image.asset(
                  widget.data["url"],
                  width: (size.width - padding) / 1.8,
                ),
                const SizedBox(
                  width: padding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "单价：¥${widget.data["pirce"]}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800]),
                      ),
                      const SizedBox(
                        height: padding,
                      ),
                      Text(
                        "配送范围：10千米",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[300]),
                      ),
                      const SizedBox(
                        height: padding,
                      ),
                      Wrap(
                        spacing: padding,
                        runSpacing: padding,
                        children: lunchString
                            .map((e) => Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      color: Colors.red[200],
                                    ),
                                    const SizedBox(
                                      width: padding / 2,
                                    ),
                                    Text(e)
                                  ],
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: padding,
            ),
            const Text("美食介绍:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            const SizedBox(
              height: padding,
            ),
            Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(padding),
                width: size.width,
                child: Text(
                    "这是${widget.data["name"]},下面是我的介绍，下面是我的介绍，下面是我的介绍，下面是我的介绍")),
            const SizedBox(
              height: padding,
            ),
            const Text("产品图片:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            const SizedBox(
              height: padding,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(padding),
                  child: Image.asset(
                    widget.data["url"],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: padding * 2,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(padding)),
                  width: 150,
                  alignment: Alignment.center,
                  height: 45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, widget.data["isCollect"]);
                    },
                    child: const Text("退出",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(padding)),
                  width: 150,
                  alignment: Alignment.center,
                  height: 45,
                  child: Text("查看商家",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600])),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
