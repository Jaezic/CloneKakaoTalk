import 'package:KakaoTalk/pages/search/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchViewPage extends StatelessWidget {
  const SearchViewPage({super.key});

  static const String url = '/search';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Center(
        child: SizedBox(
          width: GetPlatform.isMobile ? null : 500,
          child: Column(
            children: [
              SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              //border: Border.all(width: 0.6, color: Colors.black.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.search,
                                ),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: controller.searchController,
                                    onSubmitted: (value) {
                                      controller.searchUser(value);
                                    },
                                    decoration: InputDecoration(
                                        hintText: "친구 검색",
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(bottom: 3, left: 5, right: 5),
                                        hintStyle: _hintStyle,
                                        isDense: true),
                                    style: _textStyle,
                                    cursorColor: Colors.black38,
                                  ),
                                ),
                                Obx(
                                  () => controller.check.value == true
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: controller.searchController.clear,
                                              child: const Icon(
                                                Icons.clear,
                                                color: Colors.grey,
                                                size: 17,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            '취소',
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    const Text(
                      '검색 결과',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.searchUserList.length,
                          itemBuilder: (context, index) => controller.searchUserList[index],
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 15);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 15);
}
