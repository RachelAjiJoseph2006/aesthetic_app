// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'home_page_model.dart';
// export 'home_page_model.dart';
// import 'secondpage_widget.dart';

// class HomePageWidget extends StatefulWidget {
//   const HomePageWidget({super.key});

//   static String routeName = 'HomePage';
//   static String routePath = '/homePage';

//   @override
//   State<HomePageWidget> createState() => _HomePageWidgetState();
// }

// class _HomePageWidgetState extends State<HomePageWidget> {
//   late HomePageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = HomePageModel();
//   }

//   @override
//   void dispose() {
//     _model.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         body: Stack(
//           children: [
//             // Background image
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/images/slay3.png',
//                 fit: BoxFit.cover,
//               ),
//             ),

//             // Tagline + Button
//             Align(
//               alignment: const Alignment(0, 0.15),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Tagline
//                   Text(
//                     'YOUR AESTHETIC, DECODED',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.inter(
//                       color: Colors.white,
//                       fontSize: 19,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: 0.2,
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // Button
//                   SizedBox(
//                     width: 310,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, SecondpageWidget.routeName);
//                       },
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.white.withOpacity(0.40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Text(
//                         'GET STARTED',
//                         style: GoogleFonts.interTight(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 1,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/slay3.png',
              fit: BoxFit.cover,
            ),
          ),

          // Text ABOVE button
          Align(
            alignment: const Alignment(0, 0.05),
            child: Text(
              'YOUR AESTHETIC, DECODED',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Button
          Align(
            alignment: const Alignment(0, 0.2),
            child: SizedBox(
              width: 300,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'GET STARTED',
                  style: GoogleFonts.interTight(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'index.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'home_page_model.dart';
// export 'home_page_model.dart';

// class HomePageWidget extends StatefulWidget {
//   const HomePageWidget({super.key});

//   static String routeName = 'HomePage';
//   static String routePath = '/homePage';

//   @override
//   State<HomePageWidget> createState() => _HomePageWidgetState();
// }

// class _HomePageWidgetState extends State<HomePageWidget> {
//   late HomePageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => HomePageModel());
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         key: scaffoldKey,
//         body: Stack(
//           children: [
//             Align(
//               alignment: AlignmentDirectional(0, 0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   'assets/images/slay3.png',
//                   width: 446.6,
//                   height: 883.89,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: AlignmentDirectional(0.03, 0.14),
//               child: FFButtonWidget(
//                 onPressed: () async {
//                   context.pushNamed(SecondpageWidget.routeName);
//                 },
//                 text: 'GET STARTED',
//                 options: FFButtonOptions(
//                   width: 310,
//                   height: 40,
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                   iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                   color: Color(0x69FFFFFF),
//                   textStyle: FlutterFlowTheme.of(context).titleSmall.override(
//                         font: GoogleFonts.interTight(
//                           fontWeight: FlutterFlowTheme.of(context)
//                               .titleSmall
//                               .fontWeight,
//                           fontStyle:
//                               FlutterFlowTheme.of(context).titleSmall.fontStyle,
//                         ),
//                         color: Colors.white,
//                         letterSpacing: 0.0,
//                         fontWeight:
//                             FlutterFlowTheme.of(context).titleSmall.fontWeight,
//                         fontStyle:
//                             FlutterFlowTheme.of(context).titleSmall.fontStyle,
//                       ),
//                   elevation: 0,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: AlignmentDirectional(0, 0),
//               child: Text(
//                 'YOUR AESTHETIC, DECODED',
//                 textAlign: TextAlign.center,
//                 style: FlutterFlowTheme.of(context).bodyLarge.override(
//                       font: GoogleFonts.inter(
//                         fontWeight: FontWeight.w500,
//                         fontStyle:
//                             FlutterFlowTheme.of(context).bodyLarge.fontStyle,
//                       ),
//                       color: Colors.white,
//                       fontSize: 19,
//                       letterSpacing: 0.0,
//                       fontWeight: FontWeight.w500,
//                       fontStyle:
//                           FlutterFlowTheme.of(context).bodyLarge.fontStyle,
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
