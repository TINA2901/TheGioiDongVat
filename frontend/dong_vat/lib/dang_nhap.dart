import 'dart:convert';
import 'package:dong_vat/dang_ky.dart';
import 'package:dong_vat/danh_muc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  bool _anMatKhau = true;

  // --- SỬA Ở ĐÂY: Đưa controller ra ngoài hàm build ---
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPass = TextEditingController();
  // ----------------------------------------------------

  // Nên thêm hàm dispose để dọn dẹp bộ nhớ khi tắt màn hình
  @override
  void dispose() {
    txtEmail.dispose();
    txtPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // KHÔNG khai báo controller ở đây nữa
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text(
                  "THẾ GIỚI ĐỘNG VẬT",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // --- EMAIL ---
                TextField(
                  controller: txtEmail, // Gắn controller vào đây
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- MẬT KHẨU ---
                TextField(
                  controller: txtPass, // Gắn controller vào đây
                  obscureText: _anMatKhau,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _anMatKhau ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _anMatKhau = !_anMatKhau;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- NÚT ĐĂNG NHẬP ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      var client = http.Client();
                      var url = Uri.parse("http://localhost:3000/api/auth/login");
                        var res = await client.post(
                          url,
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "email": txtEmail.text, 
                            "password": txtPass.text,
                          }),
                        );

                        print("Status Code: ${res.statusCode}");
                        var resp = jsonDecode(res.body);

                        if (res.statusCode == 200) {
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DanhMuc()),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(resp["message"] ?? "Lỗi đăng nhập"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- CHUYỂN TRANG ĐĂNG KÝ ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DangKy()),
                        );
                      },
                      child: const Text(
                        "Đăng ký ngay",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}