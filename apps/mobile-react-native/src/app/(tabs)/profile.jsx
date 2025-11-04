import React, { useRef, useState, useEffect } from "react";
import {
  View,
  Animated,
  Text,
  ScrollView,
  TouchableOpacity,
} from "react-native";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { useQuery } from "@tanstack/react-query";
import { User, LogOut } from "lucide-react-native";
import { useAppTheme } from "../../components/theme";
import ScreenHeader from "../../components/ScreenHeader";
import EmptyState from "../../components/EmptyState";
import { getSessionId } from "../../utils/sessionStorage";
import {
  useFonts,
  Montserrat_400Regular,
  Montserrat_600SemiBold,
  Montserrat_500Medium,
} from "@expo-google-fonts/montserrat";

export default function ProfileScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const theme = useAppTheme();
  const scrollY = useRef(new Animated.Value(0)).current;
  const [sessionId, setSessionId] = useState(null);

  const [fontsLoaded] = useFonts({
    Montserrat_400Regular,
    Montserrat_600SemiBold,
    Montserrat_500Medium,
  });

  useEffect(() => {
    const initSession = async () => {
      const id = await getSessionId();
      setSessionId(id);
    };
    initSession();
  }, []);

  const { data: orders = [] } = useQuery({
    queryKey: ["orders", sessionId],
    queryFn: async () => {
      if (!sessionId) return [];
      const response = await fetch(`/api/orders?sessionId=${sessionId}`);
      if (!response.ok) throw new Error("Failed to fetch orders");
      return response.json();
    },
    enabled: !!sessionId,
  });

  const RightIcon = () => <User size={24} color={theme.iconPrimary} />;

  if (!fontsLoaded || !sessionId) {
    return null;
  }

  return (
    <View style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar style={theme.isDark ? "light" : "dark"} />

      <ScreenHeader title="Profile" rightIcon={RightIcon} scrollY={scrollY} />

      <Animated.ScrollView
        style={{ flex: 1 }}
        contentContainerStyle={{
          paddingTop: insets.top + 72,
          paddingBottom: insets.bottom + 20,
          paddingHorizontal: 20,
        }}
        showsVerticalScrollIndicator={false}
        onScroll={Animated.event(
          [{ nativeEvent: { contentOffset: { y: scrollY } } }],
          { useNativeDriver: false },
        )}
        scrollEventThrottle={16}
      >
        {/* Profile Header */}
        <View
          style={{
            backgroundColor: theme.cardBackground,
            borderWidth: 1,
            borderColor: theme.border,
            borderRadius: 12,
            padding: 16,
            marginBottom: 24,
            alignItems: "center",
          }}
        >
          <View
            style={{
              width: 80,
              height: 80,
              borderRadius: 40,
              backgroundColor: theme.avatarBackground,
              alignItems: "center",
              justifyContent: "center",
              marginBottom: 12,
            }}
          >
            <User size={40} color={theme.avatarIcon} />
          </View>
          <Text
            style={{
              fontFamily: "Montserrat_600SemiBold",
              fontSize: 18,
              color: theme.primaryText,
              marginBottom: 4,
            }}
          >
            Guest User
          </Text>
          <Text
            style={{
              fontFamily: "Montserrat_400Regular",
              fontSize: 14,
              color: theme.secondaryText,
            }}
          >
            Session ID: {sessionId.slice(0, 20)}...
          </Text>
        </View>

        {/* Order History Section */}
        <Text
          style={{
            fontFamily: "Montserrat_600SemiBold",
            fontSize: 18,
            color: theme.primaryText,
            marginBottom: 16,
          }}
        >
          Order History
        </Text>

        {orders.length === 0 ? (
          <View
            style={{
              backgroundColor: theme.cardBackground,
              borderWidth: 1,
              borderColor: theme.border,
              borderRadius: 12,
              padding: 24,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <Text
              style={{
                fontFamily: "Montserrat_400Regular",
                fontSize: 14,
                color: theme.secondaryText,
                textAlign: "center",
              }}
            >
              No orders yet. Start shopping!
            </Text>
          </View>
        ) : (
          orders.map((order) => (
            <View
              key={order.id}
              style={{
                backgroundColor: theme.cardBackground,
                borderWidth: 1,
                borderColor: theme.border,
                borderRadius: 12,
                padding: 16,
                marginBottom: 12,
              }}
            >
              <View
                style={{
                  flexDirection: "row",
                  justifyContent: "space-between",
                  alignItems: "flex-start",
                  marginBottom: 8,
                }}
              >
                <View style={{ flex: 1 }}>
                  <Text
                    style={{
                      fontFamily: "Montserrat_600SemiBold",
                      fontSize: 14,
                      color: theme.primaryText,
                      marginBottom: 4,
                    }}
                  >
                    Order #{order.id}
                  </Text>
                  <Text
                    style={{
                      fontFamily: "Montserrat_400Regular",
                      fontSize: 12,
                      color: theme.secondaryText,
                    }}
                  >
                    {new Date(order.created_at).toLocaleDateString()}
                  </Text>
                </View>
                <View style={{ alignItems: "flex-end" }}>
                  <Text
                    style={{
                      fontFamily: "Montserrat_600SemiBold",
                      fontSize: 14,
                      color: theme.primaryText,
                      marginBottom: 4,
                    }}
                  >
                    ${order.total_price.toFixed(2)}
                  </Text>
                  <View
                    style={{
                      backgroundColor:
                        order.order_status === "completed"
                          ? "#22c55e"
                          : "#f59e0b",
                      paddingHorizontal: 8,
                      paddingVertical: 4,
                      borderRadius: 4,
                    }}
                  >
                    <Text
                      style={{
                        fontFamily: "Montserrat_500Medium",
                        fontSize: 11,
                        color: "#ffffff",
                        textTransform: "capitalize",
                      }}
                    >
                      {order.order_status}
                    </Text>
                  </View>
                </View>
              </View>
            </View>
          ))
        )}
      </Animated.ScrollView>
    </View>
  );
}
