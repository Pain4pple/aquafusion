import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.9,
                      child: Material(
                      color: Colors.transparent,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      ),
                        child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.45,
                        constraints: BoxConstraints(
                          minWidth: 40.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFfec583), Color(0xF4FFD9D9)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                          child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Feeder:',
                                        style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              color: Color(0xB3621A1A),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 1.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Color(0x96D00F0F),
                                          size: 35.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(
                                            'Feed Stock Running Low',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                  color: Color(0xB3621A1A),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                          width: MediaQuery.sizeOf(context).width * 0.45,
                          decoration: BoxDecoration(
                            color: Color(0xFFfeffff),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Feed Level',
                                  style: GoogleFonts.poppins(
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Approximately',
                                          style: GoogleFonts.poppins(
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          '25kg remaining',
                                          style: GoogleFonts.poppins(
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                  ]
                  )
              ),
              Expanded(
                child: Column(
                  children: [
                  Opacity(
                      opacity: 0.9,
                      child: Material(
                      color: Colors.transparent,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      ),
                        child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.45,
                        constraints: BoxConstraints(
                          minWidth: 40.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF95c9ff), Color(0xF4caefff)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                          child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Water Quality Monitoring:',
                                        style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              color: Color(0xB3072f53),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 1.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.water_drop,
                                          color: Color(0xFF0098da),
                                          size: 35.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(
                                            'Operational',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                  color: Color(0xB3072f53),
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
 
                  ]
                  )
              ),
              ],
          )
        ),
      ],
    );
  }
}
