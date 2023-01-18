package {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

[SWF(frameRate="60", backgroundColor="#000000", width="512", height="512")]
public class Main extends Sprite {
    private var seed:int = 0;
    private var islandSize:Number = 35;

    private var map:Bitmap;
    private var mapData:BitmapData;
    private var val:Number = 5;

    public function Main() {
        this.mapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x009900);

        this.generateTerrain();
    }

    private function generateTerrain():void {
        for (var x:int = 0; x < stage.stageWidth; x++) {
            for (var y:int = 0; y < stage.stageHeight; y++) {
                var nx:Number = x / stage.stageWidth * this.val;
                var ny:Number = y / stage.stageHeight * this.val;
                var noise:Number = PerlinNoise.noise(this.seed, nx, ny) * fallOffMap(x, y, stage.stageHeight, this.islandSize);
                this.mapData.setPixel(x, y, this.getTile(x, y, noise));
            }
        }
        this.map = new Bitmap(mapData);
        this.addChild(this.map);
    }

    private function getTile(x:int, y:int, noise:Number):* {
        if (noise < 0.03) return 0x696969; // rock
        if (noise < 0.15) return 0xC6EA4B; // highlands
        if (noise < 0.5) return 0x16BF32; //grass
        if (noise < 0.6) return 0xECF08B; //sand
        if (noise < 0.9) return 0x22A1E3; //water

        return 0x108DCA;
    }

    private function fallOffMap(x:Number, y:Number, size:int, islandSize:Number):Number {
        return (1 / ((x * y) / (size * size) * (1 - (x / size)) * (1 - (y / size))) - 16) / islandSize;
    }
}
}
