

class ModelMaintenanceItem {
  final String? inventoryItem;  // ex) LINEN
  final List<ModelMaintenanceSubItem>? subItems;

  ModelMaintenanceItem({
    this.inventoryItem,
    this.subItems,
  });
}

class ModelMaintenanceSubItem {
  final String? subItemName;
  final String? quantity;

  ModelMaintenanceSubItem({
    this.subItemName,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['subItemName'] = subItemName;
    data['quantity'] = quantity;
    return data;
  }
}