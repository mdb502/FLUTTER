import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/luces_provider.dart';
import '../widgets/luces/tarjeta_luz_neumorfica.dart';

class LucesExterioresScreen extends StatelessWidget {
  const LucesExterioresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lucesProv = Provider.of<LucesProvider>(context);
    final listaLuces = lucesProv.lucesExteriores; // Solo las de zona "Exterior"

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: lucesProv.cargando
          ? const Center(child: CircularProgressIndicator())
          : listaLuces.isEmpty
          ? const Center(child: Text("No hay luces configuradas en esta zona"))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemCount: listaLuces.length,
              itemBuilder: (context, index) {
                final luz = listaLuces[index];
                return TarjetaLuzNeomorfica(
                  luz: luz,
                  onPowerToggle: () {
                    print("Cambiando estado de: ${luz.etiqueta}");
                  },
                );
              },
            ),
    );
  }
}
