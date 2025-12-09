import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class AddAthleteDialog extends StatefulWidget {
  final Function onSaved; // callback to refresh parent
  const AddAthleteDialog({super.key, required this.onSaved});

  @override
  State<AddAthleteDialog> createState() => _AddAthleteDialogState();
}

class _AddAthleteDialogState extends State<AddAthleteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _gender = 'Male';
  DateTime? _dob;
  int _subscriptionId = 1; // par défaut ; tu peux charger dynamiquement la table subscriptions
  String _paid = 'Paid';
  int _amountPaid = 0;
  File? _image;

  bool _loading = false;

  Future _pickImage() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (photo != null) setState(() => _image = File(photo.path));
  }

  _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final birth = _dob != null ? _dob!.toIso8601String().split('T').first : '';
    final ok = await ApiService.addAthlete(
      firstName: _firstCtrl.text.trim(),
      lastName: _lastCtrl.text.trim(),
      gender: _gender,
      birthDate: birth,
      phone: _phoneCtrl.text.trim(),
      subscriptionId: _subscriptionId,
      paid: _paid,
      amountPaid: _amountPaid,
      imageFile: _image,
    );
    setState(() => _loading = false);
    if (ok) {
      widget.onSaved();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur lors de l'ajout")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 650,
        height: 700,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add New Athlete", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 6),
              const Text("Fill in the athlete's information to create their profile", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      backgroundColor: const Color(0xffeaeaea),
                      child: _image == null ? const Icon(Icons.person, size: 48, color: Colors.grey) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.upload, color: Colors.white, size: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(controller: _firstCtrl, decoration: const InputDecoration(labelText: "First Name *"), validator: (v) => v==null||v.isEmpty ? "Required" : null),
                        const SizedBox(height: 10),
                        TextFormField(controller: _lastCtrl, decoration: const InputDecoration(labelText: "Last Name *"), validator: (v) => v==null||v.isEmpty ? "Required" : null),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _gender,
                                items: const [
                                  DropdownMenuItem(value: "Male", child: Text("Male")),
                                  DropdownMenuItem(value: "Female", child: Text("Female")),
                                  DropdownMenuItem(value: "Other", child: Text("Other")),
                                ],
                                onChanged: (v){ if(v!=null) setState(()=>_gender=v); },
                                decoration: const InputDecoration(labelText: "Gender *"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime? d = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime(2000),
                                  );
                                  if (d!=null) setState(()=>_dob=d);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: InputDecoration(labelText: "Date of Birth", hintText: _dob==null ? "Pick a date" : _dob!.toIso8601String().split('T').first),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
                        const SizedBox(height: 10),
                        // subscription selection simple demo (IDs must exist in DB)
                        DropdownButtonFormField<int>(
                          value: _subscriptionId,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text("Basic")),
                            DropdownMenuItem(value: 2, child: Text("Premium")),
                            DropdownMenuItem(value: 3, child: Text("VIP")),
                          ],
                          onChanged: (v) { if (v!=null) setState(()=>_subscriptionId=v); },
                          decoration: const InputDecoration(labelText: "Subscription Type *"),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _paid,
                                items: const [
                                  DropdownMenuItem(value: "Paid", child: Text("Paid")),
                                  DropdownMenuItem(value: "Partial", child: Text("Partial")),
                                  DropdownMenuItem(value: "Unpaid", child: Text("Unpaid")),
                                ],
                                onChanged: (v) { if (v!=null) setState(()=>_paid=v); },
                                decoration: const InputDecoration(labelText: "Payment Status *"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                initialValue: "0",
                                decoration: const InputDecoration(labelText: "Amount Paid (DA)"),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => _amountPaid = int.tryParse(v) ?? 0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _loading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Save Athlete"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
