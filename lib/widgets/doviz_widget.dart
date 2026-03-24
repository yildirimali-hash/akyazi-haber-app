import 'package:flutter/material.dart';
import '../models/doviz_model.dart';

class DovizWidget extends StatelessWidget {
  final Doviz doviz;

  const DovizWidget({super.key, required this.doviz});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Döviz Kurları',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (doviz.dolar != null)
                Expanded(
                  child: _buildDovizItem(
                    'DOLAR',
                    '₺${doviz.dolar!.toStringAsFixed(2)}',
                    doviz.isDurumUp(doviz.dolarDurum),
                    Colors.green,
                  ),
                ),
              if (doviz.euro != null)
                Expanded(
                  child: _buildDovizItem(
                    'EURO',
                    '₺${doviz.euro!.toStringAsFixed(2)}',
                    doviz.isDurumUp(doviz.euroDurum),
                    Colors.blue,
                  ),
                ),
              if (doviz.sterlin != null)
                Expanded(
                  child: _buildDovizItem(
                    'STERLİN',
                    '₺${doviz.sterlin!.toStringAsFixed(2)}',
                    doviz.isDurumUp(doviz.sterlinDurum),
                    Colors.purple,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (doviz.altin != null)
                Expanded(
                  child: _buildDovizItem(
                    'ALTIN',
                    '₺${doviz.altin!.toStringAsFixed(2)}',
                    doviz.isDurumUp(doviz.altinDurum),
                    Colors.amber,
                  ),
                ),
              if (doviz.gumus != null)
                Expanded(
                  child: _buildDovizItem(
                    'GÜMÜŞ',
                    '₺${doviz.gumus!.toStringAsFixed(2)}',
                    doviz.isDurumUp(doviz.gumusDurum),
                    Colors.grey,
                  ),
                ),
              if (doviz.altin == null && doviz.gumus == null)
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDovizItem(String label, String value, bool isUp, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                isUp ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: isUp ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
