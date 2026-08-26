import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:mizan_pos/constants/colors.dart';
import 'package:mizan_pos/constants/icons.dart';
import 'package:mizan_pos/constants/images.dart';
import 'package:mizan_pos/constants/sizes.dart';
import 'package:mizan_pos/helpers/helper_functions.dart';
import 'package:mizan_pos/models/app_route_model.dart';
import 'package:mizan_pos/models/user_model.dart';
import 'package:mizan_pos/providers/app_info_provider.dart';
import 'package:mizan_pos/ui/ui_button_widget.dart';
import 'package:mizan_pos/ui/ui_title_widget.dart';

class SideBarWidget extends StatelessWidget {
  final List<AppRouteModel> routes;
  final int activeRouteIndex;
  final void Function(int index) onRouteClick;
  final UserModel userData;
  final bool miniSidebar;
  final bool disabled;
  final bool darkMode;
  final void Function() toggleMiniSidebar;
  final void Function() logoutClick;

  const SideBarWidget({
    super.key,
    required this.routes,
    required this.activeRouteIndex,
    required this.onRouteClick,
    required this.userData,
    required this.miniSidebar,
    required this.toggleMiniSidebar,
    required this.logoutClick,
    this.disabled = false,
    this.darkMode = true
  });

  @override
  Widget build(BuildContext context) {
    // final AppInfoProvider appInfoProvider = context.watch<AppInfoProvider>();

    // final String businessName = appInfoProvider.deviceData?.businessName ?? '---';

    return Container(
      width: miniSidebar ? 86 : 300,
      decoration: BoxDecoration(
        gradient: darkMode ? LinearGradient(colors: [ Color.fromARGB(255, 0, 0, 0), CColors.primaryColor ], begin: AlignmentGeometry.bottomCenter, end: AlignmentGeometry.topCenter, ) : null,
        color: darkMode ? null : CColors.white
      ),
      padding: EdgeInsets.symmetric(horizontal: CSizes.mediumGap),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: CHelperFunctions.availableScreenHeight(context: context)),
          child: ClipRRect(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // - - - T O P _ S E C T I O N
                Column(
                  children: [
                    SizedBox(height: CSizes.xLargeGap,),
                    
                    GestureDetector(
                      onTap: toggleMiniSidebar,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: darkMode ? CColors.black : CColors.whiteShade1,
                          border: Border.all(width: 1, color: darkMode ? Color.fromARGB(255, 0, 217, 255) : CColors.whiteShade2),
                          borderRadius: BorderRadius.circular(CSizes.mediumGap)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: miniSidebar ? CSizes.smallGap : CSizes.mediumGap),
                        child: Row(
                          mainAxisAlignment: miniSidebar ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                          children: [
                            if (!miniSidebar) Row(
                              children: [
                                Image.asset(
                                  'assets/images/mizan-logo-small-and-rounded.png',
                                  height: 40,
                                ),
                            
                                SizedBox(width: CSizes.smallGap,),
                            
                                FittedBox(
                                  child: UiTitleWidget(
                                    text: 'Mizan',
                                    color: darkMode ? CColors.white : null,
                                    bigger: true,
                                    defaultText: true,
                                    capitalizeWords: true,
                                  ),
                                ),
                            
                                SizedBox(width: CSizes.mediumGap,),
                              ],
                            ),
                        
                            UiButtonWidget(
                              icon:!miniSidebar ? CIcons.sidebarRight : CIcons.sidebarLeft,
                              onClick: toggleMiniSidebar,
                              backgroundColor: CColors.transparent,
                              color: darkMode ? null : CColors.black,
                              borderColor: CColors.transparent,
                              vericalPadding: 0,
                              horizontalPadding: 0,
                              biggerIcon: true,
                            )
                          ],
                        ),
                      ),
                    ),
                
                    SizedBox(height: CSizes.xLargeGap,),
            
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) { 
                        return GestureDetector(
                          onTap: () => onRouteClick(index),
                          child: routeDisplayWidget(
                            icon: routes[index].routeIcon, 
                            name: routes[index].routeName,
                            isActive: activeRouteIndex == index,
                            addBorder: false
                          )
                        );
                      }, 
                      separatorBuilder: (context, index) => SizedBox(height: 0,),
                      itemCount: routes.length
                    )
              
                  ],
                ),
            
            
                SizedBox(height: CSizes.xLargeGap,),
            
            
                // - - - B O T T O M _ S E C T I O N
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    Row(
                      mainAxisAlignment: miniSidebar ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        profileDisplayMethod(),
                
                        if (!miniSidebar) Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: CSizes.mediumGap,),
                                        
                              Expanded(
                                child: Text(
                                  CHelperFunctions.capitalizeWords('${userData.firstName} ${userData.middleName}'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: CColors.white
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                
                    SizedBox(height: CSizes.mediumGap,),
                
                    GestureDetector(
                      onTap: logoutClick,
                      child: routeDisplayWidget(
                        icon: CIcons.logoutIcon, 
                        name: 'logout',
                        isActive: false,
                        addBorder: true
                      ),
                    ),
                            
                    SizedBox(height: CSizes.largeGap,),
                                
                    Row(
                      mainAxisAlignment: miniSidebar ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                      children: [
                        if (!miniSidebar) UiTitleWidget(text: 'By', color: CColors.whiteShade2, bold: false,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: SvgPicture.asset(
                                CIcons.saqrIcon,
                                height: 18,
                                // colorFilter: ColorFilter.mode(CColors.white, BlendMode.srcIn),
                              ),
                            ),

                            if (!miniSidebar) Row(
                              children: [
                                SizedBox(width: CSizes.smallGap,),
                                UiTitleWidget(text: 'SAQR Innovations', color: CColors.whiteShade2, bold: false, defaultText: true,),
                              ],
                            )
                        
                            // if (!miniSidebar) SizedBox(width: CSizes.mediumGap,),
                        
                            // if (!miniSidebar) Text(
                            //   'SAQR Innovations',
                            //   style: TextStyle(
                            //     color: CColors.whiteShade2,
                            //     fontSize: 13
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                                
                    SizedBox(height: CSizes.largeGap,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }





  Container profileDisplayMethod() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: CColors.white,
        borderRadius: BorderRadius.circular(CSizes.mediumRadius+10)
      ),
      child: Center(
        child: Text(
          ('${userData.firstName.substring(0, 1)}${userData.middleName.substring(0, 1)}').toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            // color: CColors.whiteShade1
          ),
        )
      ),
    );
  }




  MouseRegion routeDisplayWidget({ 
    required String icon, 
    required String name, 
    required bool isActive, 
    bool isDisabled = false, 
    bool addBorder = true 
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isActive ? CColors.white : null,
          border: Border.all(width: 1, color: addBorder ? CColors.whiteShade2 : CColors.transparent),
          borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
        ),
        padding: EdgeInsets.all(CSizes.smallGap),
        child: Row(
          mainAxisAlignment: miniSidebar ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isActive ? CColors.black : null,
                border: Border.all(
                  width: 1, 
                  color: isActive ? CColors.transparent : Color.fromARGB(255, 2, 102, 119)
                ),
                borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
              ),
              padding: EdgeInsets.all(CSizes.smallGap),
              child: SvgPicture.asset(
                icon,
                height: 18,
                colorFilter: ColorFilter.mode(
                  CColors.whiteShade1, 
                  BlendMode.srcIn
                ),
              ),
            ),
      
            if (!miniSidebar) Row(
              children: [
                SizedBox(width: CSizes.mediumGap,),

                Text(
                  name,
                  style: TextStyle(
                    color: isActive ? CColors.black : CColors.white
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}