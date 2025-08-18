import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingCalendarPage extends StatefulWidget {
  final String propertyId;
  final bool isModal;
  const BookingCalendarPage({super.key, required this.propertyId, this.isModal = false});

  @override
  State<BookingCalendarPage> createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          rangeSelectionMode: _rangeSelectionMode,
          onRangeSelected: (start, end, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
              _rangeStart = start;
              _rangeEnd = end;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
        const SizedBox(height: 16),
        _buildBookingSummary(),
        _buildConfirmButton(),
      ],
    );
    if (widget.isModal) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: content,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservar Propiedad ${widget.propertyId}'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: content,
          ),
        ),
      );
    }
  }

  Widget _buildBookingSummary() {
    if (_rangeStart == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Por favor, selecciona una fecha de inicio.'),
      );
    }
    if (_rangeEnd == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Por favor, selecciona una fecha de fin.'),
      );
    }

    final duration = _rangeEnd!.difference(_rangeStart!).inDays + 1;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Check-in', style: TextStyle(color: Colors.grey)),
              Text(
                '${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Check-out', style: TextStyle(color: Colors.grey)),
              Text(
                '${_rangeEnd!.day}/${_rangeEnd!.month}/${_rangeEnd!.year}',
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text('Noches', style: TextStyle(color: Colors.grey)),
               Text('$duration', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
             ],
           ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
      child: ElevatedButton(
        onPressed: (_rangeStart != null && _rangeEnd != null)
            ? () {
                // TODO: Implement confirmation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reserva confirmada (simulado)')),
                );
                Navigator.of(context).pop();
              }
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: const Text('Confirmar Reserva'),
      ),
    );
  }

  Widget _buildPropertyImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: const AssetImage('assets/images/logo/whitelogo.png'), // Default image since propertyImageUrl doesn't exist
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Helper function to determine if an image is a local asset
  bool isLocalAsset(String url) {
    return url.startsWith('assets/') || url.startsWith('file://');
  }

  // Helper function to get the correct image provider
  ImageProvider getImageProvider(String url) {
    if (url.isEmpty) return const AssetImage('assets/images/logo/whitelogo.png');
    if (isLocalAsset(url)) {
      return AssetImage(url);
    } else {
      return NetworkImage(url);
    }
  }
} 