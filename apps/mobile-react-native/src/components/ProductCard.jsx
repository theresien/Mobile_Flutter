import React from "react";
import { View, Text, TouchableOpacity, Image } from "react-native";
import { Heart } from "lucide-react-native";
import { useRouter } from "expo-router";
import { useAppTheme } from "./theme";
import {
  useFonts,
  Montserrat_400Regular,
  Montserrat_600SemiBold,
  Montserrat_500Medium,
} from "@expo-google-fonts/montserrat";

const ProductCard = ({ product, index, isFavorited, onToggleFavorite }) => {
  const theme = useAppTheme();
  const router = useRouter();

  const [fontsLoaded] = useFonts({
    Montserrat_400Regular,
    Montserrat_600SemiBold,
    Montserrat_500Medium,
  });

  if (!fontsLoaded) {
    return null;
  }

  return (
    <TouchableOpacity
      style={{
        backgroundColor: theme.cardBackground,
        borderWidth: 1,
        borderColor: theme.border,
        borderRadius: 12,
        padding: 12,
        marginBottom: 16,
        marginRight: index % 2 === 0 ? 8 : 0,
        marginLeft: index % 2 === 1 ? 8 : 0,
        flex: 1,
      }}
      onPress={() => router.push(`/product/${product.id}`)}
    >
      <TouchableOpacity
        style={{
          position: "absolute",
          top: 12,
          right: 12,
          zIndex: 1,
        }}
        onPress={(e) => {
          e.stopPropagation();
          onToggleFavorite(product.id);
        }}
      >
        <Heart
          size={20}
          color={isFavorited ? theme.heartColor : theme.tertiaryText}
          fill={isFavorited ? theme.heartColor : "none"}
        />
      </TouchableOpacity>

      <View style={{ alignItems: "center", marginBottom: 12 }}>
        <Image
          source={{ uri: product.image_url }}
          style={{
            width: 80,
            height: 80,
            resizeMode: "contain",
          }}
        />
      </View>

      <Text
        style={{
          fontFamily: "Montserrat_400Regular",
          fontSize: 10,
          color: theme.secondaryText,
          textTransform: "uppercase",
          marginBottom: 4,
        }}
      >
        {product.brand}
      </Text>

      <Text
        style={{
          fontFamily: "Montserrat_600SemiBold",
          fontSize: 14,
          color: theme.primaryText,
          marginBottom: 4,
        }}
      >
        {product.name}
      </Text>

      <Text
        style={{
          fontFamily: "Montserrat_500Medium",
          fontSize: 16,
          color: theme.primaryText,
        }}
      >
        ${parseFloat(product.price).toFixed(2)}
      </Text>
    </TouchableOpacity>
  );
};

export default ProductCard;
