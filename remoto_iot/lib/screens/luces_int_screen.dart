import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/luces_provider.dart';
import '../widgets/luces/tarjeta_luz_neumorfica.dart';
import '../services/mqtt_mgr.dart';

class LucesInterioresScreen extends StatelessWidget {
  const LucesInterioresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al Provider
    final lucesProv = Provider.of<LucesProvider>(context);
    final listaLuces = lucesProv.lucesInteriores; // Solo las de zona "Interior"
    final mqttMgr = Provider.of<MqttMgr>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC), // Fondo Neumórfico

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
                    // Construimos el comando (1 para encender, 0 para apagar)
                    String comando = luz.encendido ? '0' : '1';

                    // Enviamos al tópico /set que calculamos dinámicamente
                    mqttMgr.publicarComando(luz.topicSet, comando);
                  },
                );
              },
            ),
    );
  }
}
