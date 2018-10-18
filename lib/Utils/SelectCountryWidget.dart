import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

class SelectCountry extends StatefulWidget {
  SelectCountry(this.showname, this.initialCountryCode);

  final bool showname;
  final String initialCountryCode;
  String selectedIsoCode;

  String getSelectedIsoCode() {
    return selectedIsoCode;
  }

  @override
  createState() => SelectCountryState();
}

class SelectCountryState extends State<SelectCountry> {
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode("fr");
  bool builded = false;

  @override
  Widget build(BuildContext context) {
    if (!builded) {
      _selectedDialogCountry =
          CountryPickerUtils.getCountryByIsoCode(widget.initialCountryCode);
      builded = true;
    }
    widget.selectedIsoCode = _selectedDialogCountry.isoCode;

    Widget _buildDialogItem(Country country) => Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Text("+${country.phoneCode}"),
            SizedBox(width: 8.0),
            Flexible(child: Text(country.name))
          ],
        );

    Widget showSelectedCountry(Country country, bool showname) => Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(
                child: showname
                    ? Text(country.name)
                    : Text("+${country.phoneCode}"))
          ],
        );

    void _openCountryPickerDialog() => showDialog(
          context: context,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.pink),
              child: CountryPickerDialog(
                  titlePadding: EdgeInsets.all(8.0),
                  searchCursorColor: Colors.pinkAccent,
                  searchInputDecoration: InputDecoration(hintText: 'Search...'),
                  isSearchable: true,
                  title: Text('Select your country'),
                  onValuePicked: (Country country) => setState(() {
                        _selectedDialogCountry = country;
                        widget.selectedIsoCode = country.isoCode;
                      }),
                  itemBuilder: _buildDialogItem)),
        );

    return Container(
      decoration: new BoxDecoration(border: new Border.all(color: Colors.grey)),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: new GestureDetector(
                      onTap: _openCountryPickerDialog,
                      child: showSelectedCountry(
                          _selectedDialogCountry, widget.showname)))),
          Icon(Icons.arrow_drop_down, color: Colors.lightGreen)
        ],
      ),
    );
  }
}
