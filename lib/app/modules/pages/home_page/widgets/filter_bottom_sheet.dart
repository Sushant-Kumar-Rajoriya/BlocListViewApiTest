import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/repository_bloc/repository_bloc.dart';
import '../../../blocs/repository_bloc/repository_event.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  DateTime _selectedDate = DateTime(2022, 4, 29); // Default date
  String _sort = 'stars';
  String _order = 'desc';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Filter Repositories',
              style: Theme.of(context).textTheme.headlineLarge),
          ListTile(
            title: Text(
                'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDate,
            ),
          ),
          DropdownButton<String>(
            value: _sort,
            items: <String>[
              'stars',
              'forks',
              'updated',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _sort = newValue!;
              });
            },
            hint: const Text('Select Sort'),
          ),
          DropdownButton<String>(
            value: _order,
            items: <String>[
              'desc',
              'asc',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _order = newValue!;
              });
            },
            hint: const Text('Select Order'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(2022, 4, 29);
                    _sort = 'stars';
                    _order = 'desc';
                  });
                  BlocProvider.of<RepositoryBloc>(context).add(
                    FetchRepositories(
                      date: _selectedDate.toLocal().toString().split(' ')[0],
                      sort: _sort,
                      order: _order,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Reset Filters'),
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<RepositoryBloc>(context).add(
                    FetchRepositories(
                      date: _selectedDate.toLocal().toString().split(' ')[0],
                      sort: _sort,
                      order: _order,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
