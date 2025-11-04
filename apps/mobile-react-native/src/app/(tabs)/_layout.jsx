import { Tabs } from "expo-router";
import { Home, ShoppingCart, Heart, User } from "lucide-react-native";
import { useAppTheme } from "../../components/theme";

export default function TabLayout() {
  const theme = useAppTheme();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: theme.background,
          borderTopWidth: 1,
          borderColor: theme.border,
        },
        tabBarActiveTintColor: theme.iconPrimary,
        tabBarInactiveTintColor: theme.secondaryText,
        tabBarLabelStyle: {
          fontSize: 12,
        },
      }}
    >
      <Tabs.Screen
        name="home"
        options={{
          title: "Browse",
          tabBarIcon: ({ color, focused }) => (
            <Home color={color} size={24} fill={focused ? color : "none"} />
          ),
        }}
      />
      <Tabs.Screen
        name="cart"
        options={{
          title: "Cart",
          tabBarIcon: ({ color, focused }) => (
            <ShoppingCart
              color={color}
              size={24}
              fill={focused ? color : "none"}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="favorites"
        options={{
          title: "Favorites",
          tabBarIcon: ({ color, focused }) => (
            <Heart color={color} size={24} fill={focused ? color : "none"} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: "Profile",
          tabBarIcon: ({ color, focused }) => (
            <User color={color} size={24} fill={focused ? color : "none"} />
          ),
        }}
      />
    </Tabs>
  );
}
