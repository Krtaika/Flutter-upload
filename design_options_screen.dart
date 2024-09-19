import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'design_provider.dart';

class DesignOptionsScreen extends StatelessWidget {
  const DesignOptionsScreen({Key? key}) : super(key: key); // Adding key parameter

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DesignProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Design Options')), // Regular Text
      body: provider.designOptions.isNotEmpty
          ? ListView.builder(
              itemCount: provider.designOptions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Design Suggestion ${index + 1}'),
                    subtitle: Text(provider.designOptions[index]),
                  ),
                );
              },
            )
          : Center(child: Text('No design options available')), // Regular Text
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? choice = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Options'), // Regular Text
                content: Text('Do you want to make changes or save the design?'), // Regular Text
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Change'),
                    child: Text('Need any changes?'), // Regular Text
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Save'),
                    child: Text('Saved Design'), // Regular Text
                  ),
                ],
              );
            },
          );

          if (choice == 'Change') {
            String userRequest = "Please specify the changes needed"; // Implement input dialog for user request
            await provider.suggestChanges(userRequest);
          } else if (choice == 'Save') {
            provider.saveDesign();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Design saved!'))); // Regular Text
          }
        },
        child: Icon(Icons.more_horiz), // Regular Icon
      ),
    );
  }
}