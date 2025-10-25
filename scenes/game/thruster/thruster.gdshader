shader_type canvas_item;

uniform float exhaustTemperature : hint_range(1000.0, 10000.0, 10.0) = 3000.0;
uniform float exhaustTemperatureRandom : hint_range(0.0, 1000, 1) = 100.0;
uniform float exhaustTemperatureDecayRate : hint_range(0.0, 5.0, 0.1) = 2.0;
//uniform float exhaustTemperatureDecayDistance : hint_range(0.0, 10.0, 0.1) = 2.0;

vec3 KelvinToRGB(float kelvinTemp) {
    float red;
    float green;
    float blue;
    kelvinTemp = kelvinTemp / 100.0;

    // Red
    if (kelvinTemp <= 66.0) {
        red = 1.0;
    } else {
        red = kelvinTemp - 60.0;
        red = 329.698727446 * pow(red, -0.1332047592);
        red = clamp(red / 255.0, 0.0, 1.0);
    }

    // Green
    if (kelvinTemp <= 66.0) {
        green = 99.4708025861 * log(kelvinTemp) - 161.1195681661;
        green = clamp(green / 255.0, 0.0, 1.0);
    } else {
        green = kelvinTemp - 60.0;
        green = 288.1221695283 * pow(green, -0.0755148492);
        green = clamp(green / 255.0, 0.0, 1.0);
    }

    // Blue
    if (kelvinTemp >= 66.0) {
        blue = 1.0;
    } else if (kelvinTemp <= 19.0) {
        blue = 0.0;
    } else {
        blue = kelvinTemp - 10.0;
        blue = 138.5177312231 * log(blue) - 305.0447927307;
        blue = clamp(blue / 255.0, 0.0, 1.0);
    }

    return vec3(red, green, blue);
}

uint triple32(uint x) {
    x ^= x >> 17U;
    x *= 0xed5ad4bbU;
    x ^= x >> 11U;
    x *= 0xac4c1b51U;
    x ^= x >> 15U;
    x *= 0x31848babU;
    x ^= x >> 14U;
    return x;
}

uint hashPixel(vec2 p) {
    return triple32(triple32(uint(p.x * 1000.0)) + uint(p.y * 1000.0));
}

float random(uint seed) {
	const float UINT_SCALE = 4294967296.0;
	return (float(triple32(seed)) / UINT_SCALE) * 2.0 - 1.0;
}

void fragment() {
	float particleLife = COLOR.a;

	float decay = particleLife;
	//decay += distance(0.5, SCREEN_UV.x) * exhaustTemperatureDecayDistance;
	float temperature = 0.0 + (exhaustTemperature - 0.0) * exp(-exhaustTemperatureDecayRate * decay);
	temperature += random(hashPixel(SCREEN_UV) + uint(TIME * 1000.0)) * exhaustTemperatureRandom;

	COLOR.rgb = KelvinToRGB(temperature);
	COLOR.a = 1.0-particleLife * 0.5;
}