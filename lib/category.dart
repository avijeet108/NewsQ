import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:newsq/model.dart';
import 'package:newsq/NewsView.dart';

class Category extends StatefulWidget {
  String? query;
  Category({this.query});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];

  bool isLoading = true;
  String? url;
  Future<void> getNewsByQuery(String? query) async {
    if (query == "Entertainment" ||
        query == "Science" ||
        query == "Health" ||
        query == "Sports" ||
        query == "Technology" ||
        query == "Business")
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=$query&apiKey=88a32070974e4fe59a70bdf5b9d49e35";
    else
      url =
          "https://newsapi.org/v2/everything?q=query&from=2021-11-27&sortBy=publishedAt&apiKey=88a32070974e4fe59a70bdf5b9d49e35";
    Response response = await get(Uri.parse(url!));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsQ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      widget.query!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.indigo),
                    ),
                  ],
                ),
              ),
              isLoading == true
                  ? Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        try {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsView(
                                            newsModelList[index].newsUrl)));
                              },
                              child: Card(
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          newsModelList[index].newsImg,
                                          fit: BoxFit.fitHeight,
                                          height: 230,
                                          width: double.infinity),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: const TextStyle(
                                                  color: Colors.limeAccent,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              newsModelList[index]
                                                          .newsDes
                                                          .length >
                                                      50
                                                  ? "${newsModelList[index].newsDes.substring(0, 49)}...."
                                                  : newsModelList[index]
                                                      .newsDes,
                                              style: const TextStyle(
                                                  color: Colors.tealAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          print(e);
                          return Container();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
