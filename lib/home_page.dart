import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_page.dart';
import 'memo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

Future<void> loadMemos() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('memos');

  print("========== 読み込み ==========");
  print(jsonString);

  if (jsonString != null) {
    final List decoded = jsonDecode(jsonString);

    memos = decoded.map((e) => Memo.fromJson(e)).toList();
    memos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    setState(() {});
  }
}
  Future<void> saveMemos() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonList = memos.map((e) => e.toJson()).toList();

  await prefs.setString(
    'memos',
    jsonEncode(jsonList),
  );

  print("========== 保存 ==========");
  print(prefs.getString('memos'));
}

  String formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  void sortMemos() {
    memos.sort(
      (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("メモ一覧"),
        centerTitle: true,
      ),
      body: memos.isEmpty
          ? const Center(
              child: Text(
                "保存されているメモはありません",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      memo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        Text(
                          memo.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "作成：${formatDate(memo.createdAt)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          "更新：${formatDate(memo.updatedAt)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPage(
                            memo: memo,
                          ),
                        ),
                      );

                      if (result == "delete") {
                        setState(() {
                          memos.removeAt(index);
                          sortMemos();
                        });

                        saveMemos();
                      } else if (result is Memo) {
                        setState(() {
                          memos[index] = result;
                          sortMemos();
                        });

                        saveMemos();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditPage(),
            ),
          );

          if (result is Memo) {
            setState(() {
              memos.add(result);
              sortMemos();
            });

            saveMemos();
          }
        },
      ),
    );
  }
}