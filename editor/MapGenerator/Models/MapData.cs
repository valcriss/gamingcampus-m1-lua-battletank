using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MapGenerator.Models
{
    internal class MapData
    {
        public int Width { get; set; }
        public int Height { get; set; }
        public Dictionary<int, string> TilesAssets { get; set; }
        public Dictionary<int,int?> Layer0 {  get; set; }
        public Dictionary<int, int?> Layer1 { get; set; }
        public Dictionary<int, bool> Block { get; set; }

        public MapData(int width,int height)
        {
            Width = width;
            Height = height;
            TilesAssets = new Dictionary<int, string>();
            Layer0 = new Dictionary<int,int?>();
            Layer1 = new Dictionary<int,int?>();
            Block = new Dictionary<int,bool>();
        }
    }
}
