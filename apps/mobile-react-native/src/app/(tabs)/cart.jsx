import React, { useRef, useState, useEffect } from "react";
import {
  View,
  Animated,
  ScrollView,
  Text,
  TouchableOpacity,
  Image,
} from "react-native";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { ShoppingCart, X } from "lucide-react-native";
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

export default function CartScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const theme = useAppTheme();
  const scrollY = useRef(new Animated.Value(0)).current;
  const queryClient = useQueryClient();
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

  const { data: cartItems = [] } = useQuery({
    queryKey: ["cart", sessionId],
    queryFn: async () => {
      if (!sessionId) return [];
      const response = await fetch(`/api/cart?sessionId=${sessionId}`);
      if (!response.ok) throw new Error("Failed to fetch cart");
      return response.json();
    },
    enabled: !!sessionId,
  });

  const removeFromCartMutation = useMutation({
    mutationFn: async (cartItemId) => {
      const response = await fetch(`/api/cart?cartItemId=${cartItemId}`, {
        method: "DELETE",
      });
      if (!response.ok) throw new Error("Failed to remove item");
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries(["cart", sessionId]);
    },
  });

  const createOrderMutation = useMutation({
    mutationFn: async () => {
      const response = await fetch("/api/orders", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, cartItems }),
      });
      if (!response.ok) throw new Error("Failed to create order");
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries(["cart", sessionId]);
      queryClient.invalidateQueries(["orders", sessionId]);
      router.push("/(tabs)/profile");
    },
  });

  const handleGoHome = () => {
    router.push("/(tabs)/home");
  };

  const handleRemoveItem = (cartItemId) => {
    removeFromCartMutation.mutate(cartItemId);
  };

  const handleCheckout = () => {
    createOrderMutation.mutate();
  };

  const RightIcon = () => <ShoppingCart size={24} color={theme.iconPrimary} />;

  const totalPrice = cartItems.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0,
  );

  if (!fontsLoaded || !sessionId) {
    return null;
  }

  if (cartItems.length === 0) {
    return (
      <View style={{ flex: 1, backgroundColor: theme.background }}>
        <StatusBar style={theme.isDark ? "light" : "dark"} />

        <ScreenHeader
          title="Shopping Cart"
          rightIcon={RightIcon}
          scrollY={scrollY}
        />

        <Animated.ScrollView
          style={{ flex: 1 }}
          contentContainerStyle={{
            paddingTop: insets.top + 72,
            paddingBottom: insets.bottom + 20,
            flexGrow: 1,
          }}
          showsVerticalScrollIndicator={false}
          onScroll={Animated.event(
            [{ nativeEvent: { contentOffset: { y: scrollY } } }],
            { useNativeDriver: false },
          )}
          scrollEventThrottle={16}
        >
          <EmptyState
            icon={ShoppingCart}
            title="Your cart is empty"
            description="Add some products to get started with your shopping"
            buttonText="Start Shopping"
            onButtonPress={handleGoHome}
          />
        </Animated.ScrollView>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar style={theme.isDark ? "light" : "dark"} />

      <ScreenHeader
        title="Shopping Cart"
        rightIcon={RightIcon}
        scrollY={scrollY}
      />

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
        {/* Cart Items */}
        {cartItems.map((item) => (
          <View
            key={item.id}
            style={{
              backgroundColor: theme.cardBackground,
              borderWidth: 1,
              borderColor: theme.border,
              borderRadius: 12,
              padding: 16,
              marginBottom: 16,
              flexDirection: "row",
              alignItems: "center",
            }}
          >
            <Image
              source={{ uri: item.image_url }}
              style={{
                width: 60,
                height: 60,
                borderRadius: 8,
                marginRight: 12,
              }}
            />

            <View style={{ flex: 1 }}>
              <Text
                style={{
                  fontFamily: "Montserrat_600SemiBold",
                  fontSize: 14,
                  color: theme.primaryText,
                  marginBottom: 4,
                }}
              >
                {item.name}
              </Text>
              <Text
                style={{
                  fontFamily: "Montserrat_400Regular",
                  fontSize: 12,
                  color: theme.secondaryText,
                  marginBottom: 8,
                }}
              >
                {item.brand}
              </Text>
              <View style={{ flexDirection: "row", alignItems: "center" }}>
                <Text
                  style={{
                    fontFamily: "Montserrat_500Medium",
                    fontSize: 14,
                    color: theme.primaryText,
                  }}
                >
                  Qty: {item.quantity}
                </Text>
                <Text
                  style={{
                    fontFamily: "Montserrat_600SemiBold",
                    fontSize: 14,
                    color: theme.primaryText,
                    marginLeft: "auto",
                  }}
                >
                  ${(item.price * item.quantity).toFixed(2)}
                </Text>
              </View>
            </View>

            <TouchableOpacity
              style={{ marginLeft: 12, padding: 8 }}
              onPress={() => handleRemoveItem(item.id)}
            >
              <X size={20} color={theme.secondaryText} />
            </TouchableOpacity>
          </View>
        ))}

        {/* Summary Section */}
        <View
          style={{
            backgroundColor: theme.cardBackground,
            borderWidth: 1,
            borderColor: theme.border,
            borderRadius: 12,
            padding: 16,
            marginTop: 20,
          }}
        >
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <Text
              style={{
                fontFamily: "Montserrat_400Regular",
                fontSize: 14,
                color: theme.secondaryText,
              }}
            >
              Subtotal
            </Text>
            <Text
              style={{
                fontFamily: "Montserrat_600SemiBold",
                fontSize: 14,
                color: theme.primaryText,
              }}
            >
              ${totalPrice.toFixed(2)}
            </Text>
          </View>

          <View
            style={{
              borderTopWidth: 1,
              borderTopColor: theme.border,
              paddingTop: 12,
              marginBottom: 16,
            }}
          >
            <View
              style={{
                flexDirection: "row",
                justifyContent: "space-between",
              }}
            >
              <Text
                style={{
                  fontFamily: "Montserrat_600SemiBold",
                  fontSize: 16,
                  color: theme.primaryText,
                }}
              >
                Total
              </Text>
              <Text
                style={{
                  fontFamily: "Montserrat_600SemiBold",
                  fontSize: 16,
                  color: theme.primaryText,
                }}
              >
                ${totalPrice.toFixed(2)}
              </Text>
            </View>
          </View>

          <TouchableOpacity
            style={{
              backgroundColor: theme.buttonPrimary,
              borderRadius: 8,
              padding: 16,
              alignItems: "center",
              opacity: createOrderMutation.isPending ? 0.6 : 1,
            }}
            onPress={handleCheckout}
            disabled={createOrderMutation.isPending}
          >
            <Text
              style={{
                fontFamily: "Montserrat_600SemiBold",
                fontSize: 16,
                color: theme.buttonPrimaryText,
              }}
            >
              {createOrderMutation.isPending ? "Processing..." : "Checkout"}
            </Text>
          </TouchableOpacity>
        </View>
      </Animated.ScrollView>
    </View>
  );
}
