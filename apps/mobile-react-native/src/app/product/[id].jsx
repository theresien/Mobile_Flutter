import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Image,
  Dimensions,
  Pressable,
} from "react-native";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter, useLocalSearchParams } from "expo-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { ChevronLeft, ShoppingCart, Star, Heart } from "lucide-react-native";
import { LinearGradient } from "expo-linear-gradient";
import * as Haptics from "expo-haptics";
import { useAppTheme } from "../../components/theme";
import { getSessionId } from "../../utils/sessionStorage";
import {
  useFonts,
  BricolageGrotesque_400Regular,
  BricolageGrotesque_700Bold,
} from "@expo-google-fonts/bricolage-grotesque";
import {
  JetBrainsMono_400Regular,
  JetBrainsMono_600SemiBold,
  JetBrainsMono_800ExtraBold,
} from "@expo-google-fonts/jetbrains-mono";
import { Inter_400Regular } from "@expo-google-fonts/inter";

export default function ProductDetailsScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const theme = useAppTheme();
  const queryClient = useQueryClient();
  const { id } = useLocalSearchParams();
  const { width: screenWidth } = Dimensions.get("window");
  const [sessionId, setSessionId] = useState(null);
  const [isFavorited, setIsFavorited] = useState(false);

  const [fontsLoaded] = useFonts({
    BricolageGrotesque_400Regular,
    BricolageGrotesque_700Bold,
    JetBrainsMono_400Regular,
    JetBrainsMono_600SemiBold,
    JetBrainsMono_800ExtraBold,
    Inter_400Regular,
  });

  useEffect(() => {
    const initSession = async () => {
      const sessionId = await getSessionId();
      setSessionId(sessionId);
    };
    initSession();
  }, []);

  const { data: product, isLoading } = useQuery({
    queryKey: ["product", id],
    queryFn: async () => {
      const response = await fetch(`/api/products/${id}`);
      if (!response.ok) throw new Error("Failed to fetch product");
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

  const addToCartMutation = useMutation({
    mutationFn: async () => {
      if (!sessionId) throw new Error("Session not initialized");
      const response = await fetch("/api/cart", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          sessionId,
          productId: parseInt(id),
          quantity: 1,
        }),
      });
      if (!response.ok) throw new Error("Failed to add to cart");
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries(["cart", sessionId]);
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    },
  });

  const toggleFavoriteMutation = useMutation({
    mutationFn: async () => {
      if (!sessionId) throw new Error("Session not initialized");
      const response = await fetch("/api/favorites", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, productId: parseInt(id) }),
      });
      if (!response.ok) throw new Error("Failed to toggle favorite");
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries(["favorites", sessionId]);
      Haptics.selectionAsync();
      setIsFavorited((prev) => !prev);
    },
  });

  useEffect(() => {
    const isFav = favorites.some((f) => f.product_id === parseInt(id));
    setIsFavorited(isFav);
  }, [favorites, id]);

  const handleBackPress = async () => {
    await Haptics.selectionAsync();
    router.back();
  };

  const handleAddToCartPress = () => {
    addToCartMutation.mutate();
  };

  const handleToggleFavorite = () => {
    toggleFavoriteMutation.mutate();
  };

  const handleBuyPress = async () => {
    await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    addToCartMutation.mutate();
    setTimeout(() => {
      router.push("/(tabs)/cart");
    }, 500);
  };

  const renderStars = () => {
    const rating = product?.rating || 0;
    return Array.from({ length: 5 }, (_, index) => (
      <Star
        key={index}
        size={14}
        color={theme.starColor}
        fill={index < Math.round(rating) ? theme.starColor : "transparent"}
      />
    ));
  };

  if (!fontsLoaded || isLoading || !product || !sessionId) {
    return (
      <View style={{ flex: 1, backgroundColor: theme.background }}>
        <StatusBar style={theme.isDark ? "light" : "dark"} />
      </View>
    );
  }

  const cardMaxWidth = Math.min(screenWidth - 32, 400);

  return (
    <View style={{ flex: 1, backgroundColor: theme.background }}>
      <StatusBar style={theme.isDark ? "light" : "dark"} />

      <View
        style={{
          flex: 1,
          paddingTop: 120,
          paddingBottom: insets.bottom + 20,
        }}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: theme.cardBackground,
            overflow: "hidden",
          }}
        >
          {/* Back Button */}
          <TouchableOpacity
            style={{
              position: "absolute",
              top: 8,
              left: 8,
              zIndex: 10,
              width: 40,
              height: 40,
              backgroundColor: theme.backButtonBg,
              borderRadius: 8,
              alignItems: "center",
              justifyContent: "center",
            }}
            onPress={handleBackPress}
          >
            <ChevronLeft
              size={20}
              color={theme.backButtonIcon}
              strokeWidth={2}
            />
          </TouchableOpacity>

          <ScrollView
            style={{ flex: 1 }}
            contentContainerStyle={{ flexGrow: 1 }}
            showsVerticalScrollIndicator={false}
          >
            {/* Product Media Block */}
            <View
              style={{
                height: 280,
                alignItems: "center",
                justifyContent: "center",
                paddingTop: insets.top + 60,
                width: "100%",
              }}
            >
              {/* Gradient Background */}
              <LinearGradient
                colors={[theme.gradientStart, theme.gradientEnd]}
                style={{
                  position: "absolute",
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                }}
              />

              <Image
                source={{ uri: product.image_url }}
                style={{
                  width: "100%",
                  height: 160,
                  resizeMode: "contain",
                }}
              />

              {/* 360° Indicator */}
              <View
                style={{
                  alignItems: "center",
                  marginTop: 20,
                }}
              >
                {/* Curved line with dot */}
                <View
                  style={{
                    width: 40,
                    height: 20,
                    alignItems: "center",
                    justifyContent: "flex-end",
                    marginBottom: 4,
                  }}
                >
                  <View
                    style={{
                      width: 30,
                      height: 1,
                      backgroundColor: theme.secondaryText,
                      borderRadius: 15,
                      alignItems: "center",
                      justifyContent: "center",
                    }}
                  >
                    <View
                      style={{
                        width: 3,
                        height: 3,
                        backgroundColor: theme.secondaryText,
                        borderRadius: 1.5,
                        position: "absolute",
                      }}
                    />
                  </View>
                </View>
                <Text
                  style={{
                    fontFamily: "JetBrainsMono_400Regular",
                    fontSize: 11,
                    color: theme.secondaryText,
                  }}
                >
                  360°
                </Text>
              </View>
            </View>

            {/* Details Block */}
            <View
              style={{
                flex: 1,
                paddingHorizontal: 20,
                paddingTop: 20,
              }}
            >
              {/* Brand */}
              <Text
                style={{
                  fontFamily: "BricolageGrotesque_400Regular",
                  fontSize: 13,
                  color: theme.secondaryText,
                  marginBottom: 8,
                }}
              >
                {product.brand}
              </Text>

              {/* Title & Price Row */}
              <View
                style={{
                  flexDirection: "row",
                  justifyContent: "space-between",
                  alignItems: "flex-start",
                  marginBottom: 16,
                }}
              >
                <Text
                  style={{
                    fontFamily: "BricolageGrotesque_700Bold",
                    fontSize: 20,
                    color: theme.primaryText,
                    flex: 1,
                    paddingRight: 16,
                  }}
                >
                  {product.name}
                </Text>
                <Text
                  style={{
                    fontFamily: "JetBrainsMono_800ExtraBold",
                    fontSize: 18,
                    color: theme.primaryText,
                  }}
                >
                  ${parseFloat(product.price).toFixed(2)}
                </Text>
              </View>

              {/* Rating Row */}
              <View
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  marginBottom: 20,
                }}
              >
                <View
                  style={{
                    flexDirection: "row",
                    marginRight: 8,
                  }}
                >
                  {renderStars()}
                </View>
                <Text
                  style={{
                    fontFamily: "JetBrainsMono_600SemiBold",
                    fontSize: 12,
                    color: theme.primaryText,
                    marginRight: 4,
                  }}
                >
                  {product.rating}
                </Text>
                <Text
                  style={{
                    fontFamily: "Inter_400Regular",
                    fontSize: 12,
                    color: theme.secondaryText,
                  }}
                >
                  ({product.review_count} reviews)
                </Text>
              </View>

              {/* Description Section */}
              <Text
                style={{
                  fontFamily: "BricolageGrotesque_700Bold",
                  fontSize: 14,
                  color: theme.primaryText,
                  marginBottom: 8,
                }}
              >
                Description
              </Text>

              <Text
                style={{
                  fontFamily: "Inter_400Regular",
                  fontSize: 12,
                  lineHeight: 17,
                  color: theme.tertiaryText,
                  marginBottom: 16,
                }}
              >
                {product.description}
              </Text>

              {/* Specs Section */}
              {product.specs && (
                <>
                  <Text
                    style={{
                      fontFamily: "BricolageGrotesque_700Bold",
                      fontSize: 14,
                      color: theme.primaryText,
                      marginBottom: 8,
                    }}
                  >
                    Specifications
                  </Text>

                  <View
                    style={{
                      backgroundColor: theme.elevatedBackground,
                      borderRadius: 8,
                      padding: 12,
                      marginBottom: 32,
                    }}
                  >
                    {Object.entries(product.specs).map(([key, value]) => (
                      <View
                        key={key}
                        style={{
                          flexDirection: "row",
                          justifyContent: "space-between",
                          paddingVertical: 8,
                          borderBottomWidth: 1,
                          borderBottomColor: theme.border,
                        }}
                      >
                        <Text
                          style={{
                            fontFamily: "Inter_400Regular",
                            fontSize: 12,
                            color: theme.secondaryText,
                            textTransform: "capitalize",
                          }}
                        >
                          {key.replace("_", " ")}
                        </Text>
                        <Text
                          style={{
                            fontFamily: "JetBrainsMono_600SemiBold",
                            fontSize: 12,
                            color: theme.primaryText,
                          }}
                        >
                          {value}
                        </Text>
                      </View>
                    ))}
                  </View>
                </>
              )}
            </View>

            {/* Action Row */}
            <View
              style={{
                paddingHorizontal: 20,
                paddingBottom: 20,
                flexDirection: "row",
                gap: 8,
              }}
            >
              {/* Buy Button */}
              <Pressable
                style={({ pressed }) => ({
                  flex: 1,
                  height: 48,
                  borderRadius: 24,
                  overflow: "hidden",
                  opacity: pressed ? 0.9 : 1,
                })}
                onPress={handleBuyPress}
              >
                <LinearGradient
                  colors={[theme.buyButtonStart, theme.buyButtonEnd]}
                  style={{
                    flex: 1,
                    alignItems: "center",
                    justifyContent: "center",
                  }}
                >
                  <Text
                    style={{
                      fontFamily: "JetBrainsMono_800ExtraBold",
                      fontSize: 14,
                      color: theme.buyButtonText,
                    }}
                  >
                    Buy
                  </Text>
                </LinearGradient>
              </Pressable>

              {/* Add to Cart Button */}
              <TouchableOpacity
                style={{
                  width: 48,
                  height: 48,
                  backgroundColor: theme.cartButtonBg,
                  borderWidth: 1,
                  borderColor: theme.cartButtonBorder,
                  borderRadius: 8,
                  alignItems: "center",
                  justifyContent: "center",
                }}
                onPress={handleAddToCartPress}
              >
                <ShoppingCart size={20} color={theme.cartButtonIcon} />
              </TouchableOpacity>

              {/* Favorite Button */}
              <TouchableOpacity
                style={{
                  width: 48,
                  height: 48,
                  backgroundColor: theme.cardBackground,
                  borderWidth: 1,
                  borderColor: theme.border,
                  borderRadius: 8,
                  alignItems: "center",
                  justifyContent: "center",
                }}
                onPress={handleToggleFavorite}
              >
                <Heart
                  size={20}
                  color={isFavorited ? theme.heartColor : theme.cartButtonIcon}
                  fill={isFavorited ? theme.heartColor : "none"}
                />
              </TouchableOpacity>
            </View>
          </ScrollView>
        </View>
      </View>
    </View>
  );
}
