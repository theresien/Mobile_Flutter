import { useMemo } from "react";
import { useColorScheme } from "react-native";

export const useAppTheme = () => {
  const colorScheme = useColorScheme();

  return useMemo(() => {
    const isDark = colorScheme === "dark";
    return {
      isDark,
      background: isDark ? "#121212" : "#FFFFFF",
      cardBackground: isDark ? "#1E1E1E" : "#FFFFFF",
      elevatedBackground: isDark ? "#262626" : "#F0F0F0",
      primaryText: isDark ? "#FFFFFF" : "#161616",
      secondaryText: isDark ? "#B3B3B3" : "#8E8E93",
      tertiaryText: isDark ? "#8E8E93" : "#BDBDBD",
      border: isDark ? "#2C2C2C" : "#E5E5E5",
      inputBorder: isDark ? "#404040" : "#E5E5E5",
      searchBackground: isDark ? "#1E1E1E" : "#FFFFFF",
      buttonPrimary: isDark ? "#FFFFFF" : "#0F0F11",
      buttonPrimaryText: isDark ? "#000000" : "#FFFFFF",
      iconPrimary: isDark ? "#FFFFFF" : "#0F0F11",
      iconSecondary: isDark ? "#8E8E93" : "#8E8E93",
      heartColor: "#FF5761",
      emptyStateIcon: isDark ? "#404040" : "#E5E5E5",
      avatarBackground: isDark ? "#262626" : "#F0F0F0",
      avatarIcon: isDark ? "#8E8E93" : "#BDBDBD",
      backButtonBg: isDark ? "#333333" : "#F2F3F6",
      backButtonIcon: isDark ? "#FFFFFF" : "#3A3A3C",
      gradientStart: isDark ? "#1E1E1E" : "#FFFFFF",
      gradientEnd: isDark ? "#262626" : "#F8F8F8",
      buyButtonStart: isDark ? "#FFFFFF" : "#111111",
      buyButtonEnd: isDark ? "#E0E0E0" : "#000000",
      buyButtonText: isDark ? "#000000" : "#FFFFFF",
      cartButtonBg: isDark ? "#1E1E1E" : "#FFFFFF",
      cartButtonBorder: isDark ? "#FFFFFF" : "#000000",
      cartButtonIcon: isDark ? "#FFFFFF" : "#000000",
      starColor: "#FFB400",
    };
  }, [colorScheme]);
};
