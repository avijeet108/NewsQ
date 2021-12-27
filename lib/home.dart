import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newsq/NewsView.dart';
import 'package:newsq/category.dart';
import 'package:newsq/model.dart';
import 'package:http/http.dart';
import 'dart:convert';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController searchController = TextEditingController();

  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];

  List<String> navItem = [
    "Entertainment",
    "Science",
    "Health",
    "Sports",
    "Technology",
    "Business",
  ];

  bool isLoading = true;
  Future<void> getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String? url =
        "https://newsapi.org/v2/top-headlines?country=in&category=$query&apiKey=88a32070974e4fe59a70bdf5b9d49e35";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });

          if (i == 5) break;
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<void> getNewsofIndia() async {
    Map element;
    int i = 0;
    String? url =
        "https://newsapi.org/v2/top-headlines?country=in&category=General&apiKey=88a32070974e4fe59a70bdf5b9d49e35";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });

          if (i == 10) break;
        } catch (e) {
          print(e);
        }
      }
    });
  }

  // Future<void> getNewsofIndia() async {
  //   String? url =
  //       "https://newsapi.org/v2/top-headlines?country=in&category=General&apiKey=88a32070974e4fe59a70bdf5b9d49e35";
  //   Response response = await get(Uri.parse(url));
  //   Map data = jsonDecode(response.body);
  //   setState(() {
  //     data["articles"].forEach((element) {
  //       NewsQueryModel newsQueryModel = NewsQueryModel();
  //       newsQueryModel = NewsQueryModel.fromMap(element);
  //       newsModelListCarousel.add(newsQueryModel);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getNewsByQuery("general");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsQ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          hintText: "Search anything on NewsQ...."),
                      onSubmitted: (value) {
                        if (value == "") {
                          print("BLANK SEARCH");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(query: value)));
                        }
                      },
                      // decoration: const InputDecoration(
                      //     border: InputBorder.none,
                      //     hintText: "Search anything on NewsQ"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Category(query: searchController.text)));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Icon(
                        Icons.search,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navItem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Category(
                                      query: navItem[index],
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            navItem[index],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: isLoading == true
                  ? Container(
                      height: 200,
                      child: const Center(child: CircularProgressIndicator()))
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: newsModelListCarousel.map((instance) {
                        return Builder(
                          builder: (BuildContext context) {
                            try {
                              return Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsView(instance.newsUrl)));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            instance.newsImg,
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 10),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(instance.newsHead,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.limeAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
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
                        );
                      }).toList(),
                    ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Latest News",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                  isLoading == true
                      ? Container(
                          height: MediaQuery.of(context).size.height - 450,
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                    Colors.black12
                                                        .withOpacity(0),
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Category(
                                            query: "General",
                                          )));
                            },
                            child: const Text("Show More"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 88a32070974e4fe59a70bdf5b9d49e35