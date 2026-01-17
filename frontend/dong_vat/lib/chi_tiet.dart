import 'package:flutter/material.dart';
import 'package:dong_vat/dataclass_dong_vat.dart';

class ChiTietDongVat extends StatelessWidget {
  final DataclassDongVat dongVat;

  const ChiTietDongVat({super.key, required this.dongVat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          dongVat.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SỬA LỖI ẢNH BỊ CẮT Ở ĐÂY ---
            SizedBox(
              width: double.infinity,
              height: 250, // Bạn có thể tăng chiều cao này lên nếu muốn ảnh to hơn (ví dụ: 300)
              child: Image.network(
                dongVat.avatar_url,
                // Đổi từ BoxFit.cover sang BoxFit.contain để hiển thị toàn bộ ảnh
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[200], child: const Icon(Icons.pets, size: 80, color: Colors.grey)),
              ),
            ),
            // --------------------------------

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.public, "Môi trường sống:", dongVat.habitat),
                        const Divider(),
                        _buildInfoRow(Icons.restaurant, "Chế độ ăn:", dongVat.diet),
                        const Divider(),
                        _buildInfoRow(Icons.warning_amber_rounded, "Tình trạng:", dongVat.status, isWarning: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Thông tin chi tiết",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    dongVat.description ?? "Đang cập nhật...",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isWarning ? Colors.orange : Colors.green, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isWarning ? Colors.orange[800] : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}