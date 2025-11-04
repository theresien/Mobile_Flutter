import React from "react";
import { Text, TouchableOpacity } from "react-native";
import { useAppTheme } from "./theme";
import { useFonts, Montserrat_400Regular } from "@expo-google-fonts/montserrat";

const CategoryChip = ({ category, isSelected, onPress }) => {
  const theme = useAppTheme();

  const [fontsLoaded] = useFonts({
    Montserrat_400Regular,
  });

  if (!fontsLoaded) {
    return null;
  }

  return (
    <TouchableOpacity
      style={{
        backgroundColor: isSelected
          ? theme.buttonPrimary
          : theme.cardBackground,
        borderWidth: isSelected ? 0 : 1,
        borderColor: theme.border,
        borderRadius: 20,
        paddingHorizontal: 16,
        paddingVertical: 8,
        marginRight: 12,
      }}
      onPress={() => onPress(category)}
    >
      <Text
        style={{
          fontFamily: "Montserrat_400Regular",
          fontSize: 14,
          color: isSelected ? theme.buttonPrimaryText : theme.tertiaryText,
        }}
      >
        {category}
      </Text>
    </TouchableOpacity>
  );
};

export default CategoryChip;
