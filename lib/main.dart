import 'package:flutter/material.dart';

void main() {
  // runApp inicia Flutter y coloca AgendaCitasApp como widget principal.
  runApp(const AgendaCitasApp());
}

/// Aplicación principal.
///
/// Es StatelessWidget porque la configuración general no cambia. Los datos
/// variables de la agenda se administran en PantallaAgenda.
class AgendaCitasApp extends StatelessWidget {
  const AgendaCitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorPrincipal = Color(0xFF5547D7);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Citas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrincipal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F5FC),
        // Todos los campos comparten el mismo estilo para conservar
        // consistencia visual en el formulario.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F7FC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E5F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: colorPrincipal, width: 2),
          ),
        ),
      ),
      home: const PantallaAgenda(),
    );
  }
}

/// Pantalla principal de captura y consulta de citas.
///
/// StatefulWidget conserva la lista mientras la aplicación está abierta y
/// permite actualizar la interfaz cuando se agrega una cita.
class PantallaAgenda extends StatefulWidget {
  const PantallaAgenda({super.key});

  @override
  State<PantallaAgenda> createState() => _PantallaAgendaState();
}

class _PantallaAgendaState extends State<PantallaAgenda> {
  // Los controladores permiten leer y limpiar el contenido de los TextField.
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();

  // Lista temporal en memoria. Cada Map representa una cita registrada.
  // Al cerrar la aplicación, estos datos desaparecen.
  final List<Map<String, String>> _citas = [];

  void _guardarCita() {
    final datosCita = [
      _nombreController.text,
      _fechaController.text,
      _horaController.text,
      _motivoController.text,
    ];

    if (datosCita.any((dato) => dato.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos para guardar.')),
      );
      return;
    }

    // setState avisa a Flutter que el estado cambió. Flutter vuelve a ejecutar
    // build y ListView.builder incluye inmediatamente la nueva cita.
    setState(() {
      _citas.add({
        'nombre': _nombreController.text,
        'fecha': _fechaController.text,
        'hora': _horaController.text,
        'motivo': _motivoController.text,
      });
    });

    // Se limpian los campos para poder capturar una cita nueva.
    _nombreController.clear();
    _fechaController.clear();
    _horaController.clear();
    _motivoController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Los controladores se liberan cuando la pantalla deja de existir.
    _nombreController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi agenda',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          // Esta insignia resume cuántas citas hay registradas.
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Chip(
              avatar: const Icon(Icons.event_available, size: 18),
              label: Text('${_citas.length} citas'),
              side: BorderSide.none,
              backgroundColor: const Color(0xFFEEEAFE),
            ),
          ),
        ],
      ),
      // El degradado aporta profundidad sin usar imágenes externas.
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0EDFF), Color(0xFFF9F8FD)],
          ),
        ),
        child: Center(
          // El ancho máximo evita que el contenido se estire demasiado
          // cuando la aplicación se abre en un navegador grande.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _construirEncabezado(),
                  const SizedBox(height: 20),
                  _construirFormulario(),
                  const SizedBox(height: 28),
                  _construirTituloDeLista(),
                  const SizedBox(height: 12),
                  _construirListaDeCitas(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Encabezado decorativo que presenta el propósito de la pantalla.
  Widget _construirEncabezado() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5547D7), Color(0xFF796BEA)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335547D7),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x33FFFFFF),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.calendar_month, color: Colors.white, size: 34),
            ),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organiza tu tiempo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Registra y consulta tus próximas citas en un solo lugar.',
                  style: TextStyle(
                    color: Color(0xFFE7E3FF),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card agrupa los campos del formulario y el botón de guardado.
  Widget _construirFormulario() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_calendar, color: Color(0xFF5547D7)),
                SizedBox(width: 10),
                Text(
                  'Nueva cita',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // TextField captura el nombre de la persona.
            TextField(
              controller: _nombreController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                hintText: 'Ejemplo: Ana López',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 14),
            // Wrap coloca fecha y hora en una fila cuando hay espacio y las
            // acomoda verticalmente en pantallas pequeñas.
            LayoutBuilder(
              builder: (context, constraints) {
                final anchoCampo = constraints.maxWidth >= 500
                    ? (constraints.maxWidth - 14) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    SizedBox(
                      width: anchoCampo,
                      child: TextField(
                        controller: _fechaController,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          hintText: '15/10/2026',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: anchoCampo,
                      child: TextField(
                        controller: _horaController,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Hora',
                          hintText: '10:30 AM',
                          prefixIcon: Icon(Icons.schedule_outlined),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            // Campo de varias líneas para explicar el motivo.
            TextField(
              controller: _motivoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                hintText: 'Ejemplo: Reunión del proyecto',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 42),
                  child: Icon(Icons.notes_outlined),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ElevatedButton llama a _guardarCita al hacer clic.
            ElevatedButton.icon(
              onPressed: _guardarCita,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Guardar cita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5547D7),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTituloDeLista() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Próximas citas',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '${_citas.length} registradas',
          style: const TextStyle(
            color: Color(0xFF6E6782),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Muestra un estado vacío o construye una tarjeta por cada cita.
  Widget _construirListaDeCitas() {
    if (_citas.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7E3F3)),
        ),
        child: const Column(
          children: [
            Icon(Icons.event_busy_outlined, size: 48, color: Color(0xFFA39CB8)),
            SizedBox(height: 12),
            Text(
              'Aún no hay citas',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Completa el formulario para registrar la primera.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF777085)),
            ),
          ],
        ),
      );
    }

    // shrinkWrap permite colocar ListView.builder dentro del desplazamiento
    // general de la pantalla sin asignarle una altura fija.
    return ListView.builder(
      itemCount: _citas.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final cita = _citas[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE8E5F2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEAFE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF5547D7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cita['nombre'] ?? '',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: [
                          _datoConIcono(
                            Icons.calendar_today_outlined,
                            cita['fecha'] ?? '',
                          ),
                          _datoConIcono(
                            Icons.schedule_outlined,
                            cita['hora'] ?? '',
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Text(
                        cita['motivo'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF645E72),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget reutilizable para mostrar la fecha u hora con un icono.
  Widget _datoConIcono(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16, color: const Color(0xFF766B9A)),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF766B9A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
