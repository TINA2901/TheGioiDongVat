import 'dart:convert';
import 'package:dong_vat/dong_vat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dong_vat/dataclass_danh_muc.dart'; 

class DanhMuc extends StatelessWidget {
  const DanhMuc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "DANH MỤC LOÀI",
          style: TextStyle(
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
      body: FutureBuilder<List<DataclassDanhMuc>>(
        future: getDSach(),
        builder: (context, snapshot) {
          // 1. Đang tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          // 2. Có lỗi xảy ra
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text("Lỗi tải dữ liệu:\n${snapshot.error}", textAlign: TextAlign.center),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có danh mục nào"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                elevation: 4, 
                shadowColor: Colors.green.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pets, color: Colors.green),
                  ),
                  title: Text(
                    item.name ?? "Không tên",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item.description ?? "Không có mô tả",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DongVat(name: item.name, id: item.id,)));
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

Future<List<DataclassDanhMuc>> getDSach() async {
  var list = List<DataclassDanhMuc>.empty(growable: true);
  var client = http.Client();
  var url = Uri.parse("http://localhost:3000/api/categories");
  var res = await client.get(url);
  var resp = jsonDecode(res.body);
  var data = resp["data"] as List<dynamic>;
  list.addAll(data.map((e) => DataclassDanhMuc.fromJson(e)));
  return list;
} 