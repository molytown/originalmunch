class ZoneResponseModel {
  bool _isSuccess;
  List<int> _zoneIds;
  String _message;
  List<ZoneData> _zoneData;
  ZoneResponseModel(this._isSuccess, this._message, this._zoneIds, this._zoneData);

  String get message => _message;
  List<int> get zoneIds => _zoneIds;
  bool get isSuccess => _isSuccess;
  List<ZoneData> get zoneData => _zoneData;
}

class ZoneData {
  int id;
  int status;
  double minimumShippingCharge;
  double perKmShippingCharge;
  String zoneCountry;
  String zoneCurrency;
  bool cod;
  bool digitalPayment;

  ZoneData(
      {this.id,
        this.status,
        this.minimumShippingCharge,
        this.perKmShippingCharge,
        this.zoneCountry,
        this.zoneCurrency,
        this.cod,
        this.digitalPayment,
      });

  ZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : null;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : null;
    zoneCountry = json['zone_country'];
    zoneCurrency = json['zone_currency'];
    cod = json['cod'];
    digitalPayment = json['digital_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
    data['zone_country'] = this.zoneCountry;
    data['zone_currency'] = this.zoneCurrency;
    data['cod'] = this.cod;
    data['digital_payment'] = this.digitalPayment;
    return data;
  }
}