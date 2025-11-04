import React, { useRef, useState, useEffect } from "react";
import { View, Animated, Text } from "react-native";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { useQuery } from "@tanstack/react-query";
import { Heart } from "lucide-react-native";
import { useAppTheme } from "../../components/theme";
import ScreenHeader from "../../components/ScreenHeader";
import EmptyState from "../../components/EmptyState";
import ProductCard from "../../components/ProductCard";
import { getSessionId } from "../../utils/sessionStorage";
import {
  useFonts,
  Montserrat_600SemiBold,
} from "@expo-google-fonts/montserrat";

export default function FavoritesScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const theme = useAppTheme();
  const scrollY = useRef(new Animated.Value(0)).current;
  const [sessionId, setSessionId] = useState(null);
  const [favoriteIds, setFavoriteIds] = useState(new Set());

  const [fontsLoaded] = useFonts({
    Montserrat_600SemiBold,
  });

  useEffect(() => {
    const initSession = async () => {
      const id = await getSessionId();
      setSessionId(id);
    };
    initSession();
  }, []);

  const { data: favorites = [] } = useQuery({
    queryKey: ["favorites", sessionId],
    queryFn: async () => {
      if (!sessionId) return [];
      const response = await fetch(`/api/favorites?sessionId=${sessionId}`);
      if (!response.ok) throw new Error("Failed to fetch favorites");
      return response.json();
    },
    enabled: !!sessionId,
  });

  useEffect(() => {
    const ids = new Set(favorites.map((f) => f.product_id));
    setFavoriteIds(ids);
  }, [favorites]);

  const handleGoHome = () => {
    router.push("/(tabs)/home");
  };

  const handleToggleFavorite = async (productId) => {
    if (!sessionId) return;
    try {
      const response = await fetch("/api/favorites", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, productId }),
      });
      if (!response.ok) throw new Error("Failed to toggle favorite");
      const result = await response.json();
      const newIds = new Set(favoriteIds);
      if (result.added) {
        newIds.add(productId);
      } else {
        newIds.delete(productId);
      }
      setFavoriteIds(newIds);
    } catch (error) {
      console.error("Error toggling favorite:", error);
    }
  };

  const RightIcon = () => (
    <Heart size={24} color={theme.heartColor} fill={theme.heartColor} />
  );

  if (!fontsLoaded || !sessionId) {
    return null;
  }

  if (favorites.length === 0) {
    return (
      <View style={{ flex: 1, backgroundColor: theme.background }}>
        <StatusBar style={theme.isDark ? "light" : "dark"} />

        <ScreenHeader
          title="Favorites"
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
            icon={Heart}
            title="No favorites yet"
            description="Tap the heart icon on products you love to see them here"
            buttonText="Browse Products"
            onButtonPress={handleGoHome}
          />
        </Animated.ScrollView>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar style={theme.isDark ? "light" : "dark"} />

      <ScreenHeader title="Favorites" rightIcon={RightIcon} scrollY={scrollY} />

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
        <Text
          style={{
            fontFamily: "Montserrat_600SemiBold",
            fontSize: 18,
            color: theme.primaryText,
            marginBottom: 16,
          }}
        >
          Saved Items
        </Text>

        <View
          style={{
            flexDirection: "row",
            justifyContent: "space-between",
            marginHorizontal: -20,
            paddingHorizontal: 20,
          }}
        >
          <View style={{ flex: 1, marginRight: 8 }}>
            {favorites.map(
              (product, index) =>
                index % 2 === 0 && (
                  <ProductCard
                    key={product.product_id}
                    product={product}
                    index={0}
                    isFavorited={favoriteIds.has(product.product_id)}
                    onToggleFavorite={handleToggleFavorite}
                  />
                ),
            )}
          </View>
          <View style={{ flex: 1, marginLeft: 8 }}>
            {favorites.map(
              (product, index) =>
                index % 2 === 1 && (
                  <ProductCard
                    key={product.product_id}
                    product={product}
                    index={1}
                    isFavorited={favoriteIds.has(product.product_id)}
                    onToggleFavorite={handleToggleFavorite}
                  />
                ),
            )}
          </View>
        </View>
      </Animated.ScrollView>
    </View>
  );
}
