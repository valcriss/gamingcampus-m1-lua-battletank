using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapGenerator.Models
{
    internal class ExportMapData
    {
        public int Width { get; set; }
        public int Height { get; set; }
        public Dictionary<string, string> TilesAssets { get; set; }
        public Dictionary<string, string> Layer0 { get; set; }
        public Dictionary<string, string> Layer1 { get; set; }
        public Dictionary<string, bool> Block { get; set; }

        public ExportMapData(int width, int height)
        {
            Width = width;
            Height = height;
            TilesAssets = new Dictionary<string, string>();
            Layer0 = new Dictionary<string, string>();
            Layer1 = new Dictionary<string, string>();
            Block = new Dictionary<string, bool>();
        }
    }
}
