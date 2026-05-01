import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SearchableLabeledDropdown extends StatefulWidget {
  final List<dynamic> items;
  final String selectedItem;
  final String? labelText;
  final String? hintText;
  final bool? isSearchEnabled;
  final TextEditingController? singleSelectSearchController;
  final String? searchHintText;
  final ValueChanged<String?> onTab;
  final String initialValue;
  final double? dropdownHeight;

  const SearchableLabeledDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    this.labelText,
    this.hintText,
    this.isSearchEnabled = false,
    this.singleSelectSearchController,
    this.searchHintText,
    required this.onTab,
    required this.initialValue,
    this.dropdownHeight,
  });

  @override
  State<SearchableLabeledDropdown> createState() => _SearchableLabeledDropdownState();
}

class _SearchableLabeledDropdownState extends State<SearchableLabeledDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.dropdownHeight ?? 50.0,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText ?? '',
          labelStyle: TextStyle(
              color:  Colors.grey,//AppColors.grayColor,
              fontSize: 16,//getFontSize(AppFontSize.f16),
              //fontFamily: FontName.dinNextW1g,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.normal
          ),
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          contentPadding: const EdgeInsets.only(left: 10, top: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(widget.hintText ?? '',style: TextStyle(height: 1.5),),/*CustomText(
              title: widget.hintText ?? '',
              height: 1.5,
            ),*/
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,//AppSize.s200,
              width: 230,//AppSize.s230,
              elevation: 1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            items: widget.items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal : 4,vertical: 8),
                  child: Text(
                   item,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,),
                    overflow: TextOverflow.visible,
                  ),
                ),
              );
            }).toList(),
            value: widget.selectedItem.isEmpty ? widget.initialValue : widget.selectedItem,
            onChanged: widget.onTab,
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 20,
            ),
            menuItemStyleData: const MenuItemStyleData(
              /* height: AppSize.s40,
              padding: getPadding(all:AppPadding.p8),*/
              height: 50, // Increase item height for better readability
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),

            ),
            dropdownSearchData: widget.isSearchEnabled!
                ? DropdownSearchData(
              searchController: widget.singleSelectSearchController,
              searchInnerWidgetHeight: 40,//AppSize.s40,
              searchInnerWidget: Container(
                height: 40,//AppSize.s40,
                padding: const EdgeInsets.only(
                  top: 8,//AppPadding.p8,
                  bottom: 4,//AppPadding.p4,
                  right: 8,//AppPadding.p8,
                  left: 8//AppPadding.p8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: widget.singleSelectSearchController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,//AppPadding.p10,
                            vertical: 10,
                          ),
                          hintText: widget.searchHintText,
                          hintStyle: TextStyle(color: Colors.grey[200],fontSize: 12),
                          border: const OutlineInputBorder(
                           // borderSide: BorderSide(color: AppColors.searchIconBoxColor),
                            borderRadius:  BorderRadius.only(
                                bottomLeft: Radius.circular(04),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(0)
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.black45,fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 30,
                      height:30,
                      padding: const EdgeInsets.all(5),
                      decoration:  const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(04),
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(04)
                        ),
                      ),
                      child:  Icon(
                        Icons.search,
                        color:  Colors.grey[600]  ,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ) : null,
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                widget.isSearchEnabled! ?  widget.singleSelectSearchController!.clear() : log("No any search");
              }
            },
          ),
        ),
      ),
    );
  }
}