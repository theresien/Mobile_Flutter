import React from "react";
import { View, Text, Animated } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useAppTheme } from "./theme";
import {
  useFonts,
  Montserrat_600SemiBold,
} from "@expo-google-fonts/montserrat";

const ScreenHeader = ({
  title,
  rightIcon: RightIconComponent,
  scrollY,
  showBorder = true,
}) => {
  const theme = useAppTheme();
  const insets = useSafeAreaInsets();

  const [fontsLoaded] = useFonts({
    Montserrat_600SemiBold,
  });

  if (!fontsLoaded) {
    return null;
  }

  const headerBorderOpacity = scrollY
    ? scrollY.interpolate({
        inputRange: [0, 10],
        outputRange: [0, 1],
        extrapolate: "clamp",
      })
    : 0;

  return (
    <Animated.View
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        backgroundColor: theme.background,
        paddingTop: insets.top,
        paddingHorizontal: 20,
        paddingVertical: 16,
        zIndex: 1000,
        borderBottomWidth: showBorder ? 1 : 0,
        borderBottomColor:
          showBorder && scrollY
            ? headerBorderOpacity.interpolate({
                inputRange: [0, 1],
                outputRange: ["transparent", theme.border],
              })
            : "transparent",
      }}
    >
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
        }}
      >
        <Text
          style={{
            fontFamily: "Montserrat_600SemiBold",
            fontSize: 20,
            color: theme.primaryText,
            flex: 1,
          }}
        >
          {title}
        </Text>
        {RightIconComponent && <RightIconComponent />}
      </View>
    </Animated.View>
  );
};

export default ScreenHeader;
