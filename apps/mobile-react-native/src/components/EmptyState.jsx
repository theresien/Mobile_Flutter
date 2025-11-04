import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { ArrowLeft } from "lucide-react-native";
import { useAppTheme } from "./theme";
import {
  useFonts,
  Montserrat_400Regular,
  Montserrat_600SemiBold,
} from "@expo-google-fonts/montserrat";

const EmptyState = ({
  icon: IconComponent,
  title,
  description,
  buttonText = "Go Back",
  onButtonPress,
  iconColor,
  showButton = true,
}) => {
  const theme = useAppTheme();

  const [fontsLoaded] = useFonts({
    Montserrat_400Regular,
    Montserrat_600SemiBold,
  });

  if (!fontsLoaded) {
    return null;
  }

  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 20,
      }}
    >
      <IconComponent
        size={64}
        color={iconColor || theme.emptyStateIcon}
        fill="none"
        strokeWidth={1}
      />
      <Text
        style={{
          fontFamily: "Montserrat_600SemiBold",
          fontSize: 18,
          color: theme.primaryText,
          marginTop: 16,
          marginBottom: 8,
          textAlign: "center",
        }}
      >
        {title}
      </Text>
      <Text
        style={{
          fontFamily: "Montserrat_400Regular",
          fontSize: 14,
          color: theme.secondaryText,
          textAlign: "center",
          marginBottom: showButton ? 24 : 0,
          lineHeight: 20,
        }}
      >
        {description}
      </Text>

      {showButton && onButtonPress && (
        <TouchableOpacity
          style={{
            backgroundColor: theme.buttonPrimary,
            paddingHorizontal: 24,
            paddingVertical: 12,
            borderRadius: 8,
            flexDirection: "row",
            alignItems: "center",
          }}
          onPress={onButtonPress}
        >
          <ArrowLeft size={16} color={theme.buttonPrimaryText} />
          <Text
            style={{
              fontFamily: "Montserrat_600SemiBold",
              fontSize: 14,
              color: theme.buttonPrimaryText,
              marginLeft: 8,
            }}
          >
            {buttonText}
          </Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

export default EmptyState;
