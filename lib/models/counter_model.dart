class CounterModel {
  int? id;
  String name;
  int value;

  CounterModel({
    this.id, 
    required this.name, 
    required this.value
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'value': value,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory CounterModel.fromMap(Map<String, dynamic> map) {
    return CounterModel(
      id: map['id'],
      name: map['name'],
      value: map['value'],
    );
  }
}
