import 'package:expanse_tracker/core/data/models/expense_model.dart';
import 'package:expanse_tracker/core/providers/main_provider.dart';
import 'package:expanse_tracker/core/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now().add(Duration(days: 1));
  DateTime? _selectedDay;

  List<ExpenseModel> _getExpenses(DateTime day) {
    return context
        .read<MainProvider>()
        .expenses
        .where(
          (e) =>
              e.timeStamp.day == day.day &&
              e.timeStamp.month == day.month &&
              e.timeStamp.year == day.year,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Calendar')),

          body: Column(
            children: [
              TableCalendar<ExpenseModel>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,

                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                //new
                eventLoader: (day) {
                  return _getExpenses(day);
                },
                //new
                calendarBuilders: CalendarBuilders<ExpenseModel>(
                  markerBuilder: (context, day, events) {
                    if (events.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_selectedDay != null) ...[
                Text(
                  'Selected date: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                ),
                //new
                Expanded(
                  child: ListView(
                    children: _getExpenses(_selectedDay!).map((expense) {
                      return ExpenseTile(expense: expense);
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
