Drawer(
     child = ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: controller.closeDrawer,
        )
      ],
    ),