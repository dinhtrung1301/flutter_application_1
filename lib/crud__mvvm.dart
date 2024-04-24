import 'dart:math';
import 'package:flutter/material.dart';

class SampleItem {
  String id;
  ValueNotifier<String> name;

  SampleItem({String? id, required String name})
  : id = id ?? generateUuid(),
  name = ValueNotifier(name);

  static String generateUuid() {
    return int.parse(
      '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
      .toRadixString(35).substring(0, 9);
    
  }
}
class SampleItemViewModel extends ChangeNotifier {
  static final _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._();
  final List<SampleItem> items = [];

  void addItem(String name) {
    items.add(SampleItem(name: name));
    notifyListeners();
  }
  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  void updateItem(String id, String newName) {
    try {
      final item = items.firstWhere((item) => item.id == id);
      item.name.value = newName;
    } catch (e) {
      debugPrint("khong tim thay muc voi id $id");
    }
  }
}
class SampleItemUpdate extends StatefulWidget {
  final String? initialName;
  const SampleItemUpdate({super.key, this.initialName});

  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}
class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController textEditingController;
  
  @override 
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialName);
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'chinh sua' : 'them moi'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(textEditingController.text);
            }, 
            icon: const Icon(Icons.save),
            )
        ],
      ),
      body: TextFormField(
        controller: textEditingController,
      ),
    );
  }
}
class SampleItemWidget extends StatelessWidget {
  final SampleItem item;
  final VoidCallback? onTap;
  const SampleItemWidget({super.key, required this.item, this.onTap});

  @override 
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: item.name, 
      builder: (context, name , child) {
        debugPrint(item.id);
        return ListTile(
          title: Text(name!),
          subtitle: Text(item.id),
          leading: const CircleAvatar(
            foregroundImage: AssetImage('anh/hi.jpg'),
          ),
          onTap: onTap,
          trailing: const Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}
class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item;
  const SampleItemDetailsView({super.key, required this.item});

  @override 
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}
class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel();
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet<String?>(
                context: context, 
                builder: (context) =>
                SampleItemUpdate(initialName: widget.item.name.value),
                ).then((value) {
                  if (value != null) {
                    viewModel.updateItem(widget.item.id, value);
                  }
                });
              },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("xac nhan xoa"),
                    content: const Text("ban co chac muon xoa muc nay?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false), 
                        child: const Text("bo qua"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true), 
                          child: const Text("xoa"),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) {
                  if (confirmed) {
                    Navigator.of(context).pop(true);
                  }
                });
              },
            ),
          ],
        ),
        body: ValueListenableBuilder<String>(
          valueListenable: widget.item.name,
          builder: (_, name, __) {
            return Center(child: Text(name));
          },
        ),
      );
    }
}
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});
  @override 
  State<SampleItemListView> createState() => _SampleItemListViewState();
}
class _SampleItemListViewState extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();
  late TextEditingController _searchController;
  late List<SampleItem> _searchResult = [];
   @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sample items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),

            onPressed: () {
              showModalBottomSheet<String?>(
                context: context, 
                builder: (context) => const SampleItemUpdate(),
                ).then((value) {
                  if (value != null) {
                    viewModel.addItem(value);
                  }
                });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchResult = viewModel.items;
              });
              showSearch(
                context: context,
                delegate: SampleItemSearchDelegate(_searchResult),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return ListView.builder(
            itemCount: _searchResult.length,
            itemBuilder: (context, index) {
              final item = _searchResult[index];
              return SampleItemWidget(
                key:  ValueKey(item.id),
                item: item,
                onTap: () {
                  Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (context) => SampleItemDetailsView(item: item),
                      ),
                  ).then((deleted) {
                    if (deleted ?? false) {
                      viewModel.removeItem(item.id);
                    }
                  });
                },
              );
            },
          );
        }),
    );
  }
}
class SampleItemSearchDelegate extends SearchDelegate<SampleItem> {
  final List<SampleItem> items;

  SampleItemSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, SampleItem(id: '', name: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredItems = items.where((item) => item.name.value.contains(query)).toList();
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          title: Text(item.name.value),
          subtitle: Text(item.id),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredItems = items.where((item) => item.name.value.contains(query)).toList();
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          title: Text(item.name.value),
          subtitle: Text(item.id),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}