import 'dart:convert';
import 'package:dong_vat/chi_tiet.dart';
import 'package:dong_vat/dataclass_dong_vat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DongVat extends StatelessWidget {
  final dynamic name;
  final dynamic id;

  const DongVat({super.key, this.name, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "$name",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<DataclassDongVat>>(
        future: getDSach(id),
        builder: (context, snapshot) {
          // 1. Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          // 2. Lỗi
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          // 3. Rỗng
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Chưa có động vật nào trong mục này"),
            );
          }

          // 4. Hiển thị dữ liệu
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(
                    10,
                  ), // Padding bên trong thẻ
                  // --- PHẦN ẢNH (ĐÃ SỬA) ---
                  leading: SizedBox(
                    width: 80, // Chiều rộng ảnh
                    height: 80, // Chiều cao ảnh
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Bo góc ảnh
                      child: Image.network(
                        item.avatar_url,
                        fit: BoxFit.cover, // Cắt ảnh cho vừa khung
                        errorBuilder: (context, error, stackTrace) {
                          // Nếu lỗi ảnh thì hiện icon con chó
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.pets, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),

                  // --- TÊN CON VẬT ---
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),

                  // --- MÔ TẢ NGẮN ---
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      item.description ?? "Chưa có mô tả",
                      maxLines: 2, // Chỉ hiện tối đa 2 dòng
                      overflow:
                          TextOverflow.ellipsis, // Dài quá thì hiện dấu ...
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChiTietDongVat(
                          dongVat: item,
                        ), // 'item' là biến trong vòng lặp
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<List<DataclassDongVat>> getDSach(int id) async {
  var list = List<DataclassDongVat>.empty(growable: true);

  var client = http.Client();

  var url = Uri.parse("http://localhost:3000/api/categories/$id");

  var res = await client.get(url);

  var resp = jsonDecode(res.body);

  var data = resp["data"] as List<dynamic>;

  list.addAll(data.map((e) => DataclassDongVat.fromJson(e)));

  return list;
}
