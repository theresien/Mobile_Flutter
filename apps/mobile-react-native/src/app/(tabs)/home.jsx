import React, { useRef, useState, useEffect } from "react";
import { View, Animated, Text, ScrollView } from "react-native";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useQuery } from "@tanstack/react-query";
import { Search } from "lucide-react-native";
import { useAppTheme } from "../../components/theme";
import ScreenHeader from "../../components/ScreenHeader";
import ProductCard from "../../components/ProductCard";
import CategoryChip from "../../components/CategoryChip";
import { getSessionId } from "../../utils/sessionStorage";
import {
  useFonts,
  Montserrat_600SemiBold,
} from "@expo-google-fonts/montserrat";

export default function HomeScreen() {
  const insets = useSafeAreaInsets();
  const theme = useAppTheme();
  const scrollY = useRef(new Animated.Value(0)).current;
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [sessionId, setSessionId] = useState(null);
  const [favoriteIds, setFavoriteIds] = useState(new Set());

  const [fontsLoaded] = useFonts({
    Montserrat_600SemiBold,
  });

  const categories = ["All", "Apple", "Samsung", "Google", "OnePlus"];

  useEffect(() => {
    const initSession = async () => {
      const id = await getSessionId();
      setSessionId(id);
    };
    initSession();
  }, []);

  const { data: products = [], isLoading } = useQuery({
    queryKey: ["products", selectedCategory],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedCategory !== "All") {
        params.append("brand", selectedCategory);
      }
      const response = await fetch(`/api/products?${params}`);
      if (!response.ok) throw new Error("Failed to fetch products");
      return response.json();
    },
  });

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

  const RightIcon = () => <Search size={24} color={theme.iconPrimary} />;

  if (!fontsLoaded || !sessionId) {
    return null;
  }

  return (
    <View style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar style={theme.isDark ? "light" : "dark"} />

      <ScreenHeader title="Browse" rightIcon={RightIcon} scrollY={scrollY} />

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
        {/* Featured Section */}
        <Text
          style={{
            fontFamily: "Montserrat_600SemiBold",
            fontSize: 18,
            color: theme.primaryText,
            marginBottom: 16,
          }}
        >
          Featured
        </Text>

        {/* Category Chips */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          style={{ marginBottom: 24, marginLeft: -20, paddingLeft: 20 }}
          contentContainerStyle={{ paddingRight: 20 }}
        >
          {categories.map((category) => (
            <CategoryChip
              key={category}
              category={category}
              isSelected={selectedCategory === category}
              onPress={() => setSelectedCategory(category)}
            />
          ))}
        </ScrollView>

        {/* Products Grid */}
        {isLoading ? (
          <Text style={{ color: theme.secondaryText }}>Loading...</Text>
        ) : (
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              marginHorizontal: -20,
              paddingHorizontal: 20,
            }}
          >
            <View style={{ flex: 1, marginRight: 8 }}>
              {products.map(
                (product, index) =>
                  index % 2 === 0 && (
                    <ProductCard
                      key={product.id}
                      product={product}
                      index={0}
                      isFavorited={favoriteIds.has(product.id)}
                      onToggleFavorite={handleToggleFavorite}
                    />
                  ),
              )}
            </View>
            <View style={{ flex: 1, marginLeft: 8 }}>
              {products.map(
                (product, index) =>
                  index % 2 === 1 && (
                    <ProductCard
                      key={product.id}
                      product={product}
                      index={1}
                      isFavorited={favoriteIds.has(product.id)}
                      onToggleFavorite={handleToggleFavorite}
                    />
                  ),
              )}
            </View>
          </View>
        )}
      </Animated.ScrollView>
    </View>
  );
}
